import os
import json
from dotenv import load_dotenv
import requests
import google.generativeai as genai
import socketio
import eventlet

# Load environment variables from .env file
load_dotenv()

# Configure Gemini API
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

# Create a Socket.IO server
sio = socketio.Server(cors_allowed_origins="*")
app = socketio.WSGIApp(sio)

# Helper Functions
def download_image(image_url, save_path):
    """Downloads the image from the given URL."""
    try:
        response = requests.get(image_url)
        response.raise_for_status()
        with open(save_path, 'wb') as f:
            f.write(response.content)
        return True
    except requests.exceptions.RequestException as e:
        print(f"Error downloading image: {e}")
        return False

def upload_to_gemini(path, mime_type=None):
    """Uploads the given file to Gemini."""
    try:
        file = genai.upload_file(path, mime_type=mime_type)
        return file
    except Exception as e:
        print(f"Error uploading to Gemini: {e}")
        return None

# Model Configuration
generation_config = {
    "temperature": 0.7,
    "top_p": 0.95,
    "top_k": 40,
    "max_output_tokens": 8192,
}
model = genai.GenerativeModel(
    model_name="gemini-2.0-flash-exp",
    generation_config=generation_config,
)

# Extraction Prompt
EXTRACTION_PROMPT = """Extract the key details about the prescribed medications from the text and structure them in JSON format. Follow these rules for extraction:

1. Medicine Name: Extract the name of the medicine accurately from the text dont add weight and no space in name eg : if CAP. ZOCLAR 500 then return ZOCLAR .

6. Start Date: 
   - Extract date from prescription
   - Add 1 day to extracted date
   - Use "YYYY-MM-DD" format
   - Return None if no date provided

7. End Date: 
   - Calculate by adding duration to start date
   - Use "YYYY-MM-DD" format
   - Return None if no start date or duration

2.  Coded Frequency (4-digits ):
   - Each bit corresponds to the number of pills for a specific time of day.
   - First Bit: Number of pills in the morning.
   - Second Bit: Number of pills in the afternoon.
   - Third Bit: Number of pills in the evening.
   - Fourth Bit: Number of pills at night.

4. Type:
   - "0" if taken before meals
   - "1" if taken after meals
   - "2" if timing is unspecified or can be taken anytime
    String

5. Dosage: Total number of pills from  frequency and number of days of each pill.


9. is_pill:
   - true if pill or capsule
   - false for other forms

keep doctor id 1 for all respponse 

Return the result as a JSON array.
for example 
{
  "doctor_id": 1,
  "start_date": "2025-03-01",
  "end_date": "2025-03-27",
  "medicineCourses": [
    {
      "medicine_name": "Omega7",
      "start_date": "2025-03-01",
      "end_date": None,
      "frequency": "1101",
      "medtype": "1",
      "is_pill": true,
      "dosage":75
    },
    {
      "medicine_name": "Aspirin",
      "start_date": "2025-03-01",
      "end_date": "2025-03-25",
      "frequency": "1101",
      "medtype": "0",
      "is_pill": true,
      "dosage":75
    }
  ]
}



note : if you are returning none somewhere send the actual none value
important: make sure you're giving correct json. python.
if the image is not prescription ten return the following json  eg "error":"error in prescription "

"""


# Event Handlers
@sio.event
def connect(sid, environ):
    print(f"Client connected: {sid}")

@sio.on("prescription_extraction")
def handle_prescription_extraction(sid, image_url):
    print(f"Received image URL from {sid}: {image_url}")
    image_path = "prescription_image.png"

    # Step 1: Download the image
    if not download_image(image_url, image_path):
        sio.emit("error", {"message": "Failed to download image."}, to=sid)
        return

    # Step 2: Upload the image to Gemini
    uploaded_file = upload_to_gemini(image_path, mime_type="image/png")
    if not uploaded_file:
        sio.emit("error", {"message": "Failed to upload image to Gemini."}, to=sid)
        return

    # Step 3: Generate response from the model
    try:
        response = model.generate_content([uploaded_file, EXTRACTION_PROMPT])
        
        # Clean and parse the response
        cleaned_response = response.text.strip()
        print("Raw Model Response:", cleaned_response)

        # Attempt to parse JSON, with fallback to cleaning
        try:
            parsed_response = json.loads(cleaned_response)
        except json.JSONDecodeError:
            # Remove code block markers if present
            cleaned_response = cleaned_response.replace("```json", "").replace("```", "")
            parsed_response = json.loads(cleaned_response)

        # Emit the parsed response
        sio.emit("prescription_extracted", parsed_response, to=sid)
    except json.JSONDecodeError as e:
        print(f"JSON Parsing Error: {e}")
        sio.emit("error", {
            "message": "Could not parse the model's response.",
            "raw_response": cleaned_response
        }, to=sid)
    except Exception as e:
        print(f"Unexpected Error: {e}")
        sio.emit("error", {"message": "Failed to process prescription."}, to=sid)

@sio.event
def disconnect(sid):
    print(f"Client disconnected: {sid}")

# Run the server
if __name__ == "__main__":
    print("Socket.IO server is running on port 3002...")
    eventlet.wsgi.server(eventlet.listen(("0.0.0.0", 3002)), app)