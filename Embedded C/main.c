
#include <WiFi.h>
#include <WebSocketsClient.h>
#include <ArduinoJson.h>

// WiFi credentials
const char* ssid = "Paras";
const char* password = "12345678";

// WebSocket server details
const char* ws_server = "192.168.249.24"; 
const int ws_port = 3000;

// Hardware pins
const int ledPins[] = {2, 4, 5, 18};       // LED GPIOs for compartments
const int hallSensorPins[] = {32, 33, 34, 35}; // Hall sensor GPIOs for lids
const int buzzerPin = 19;                  // Buzzer GPIO
const int buttonPin = 21;                  // Button GPIO

bool activeCompartments[4] = {false, false, false, false}; // Initially all false
bool hallSensorState[4] = {false, false, false, false}; // Track lid open status
bool ledsOn = false; // Initially, LEDs are OFF
unsigned long lastButtonPress = 0;
const int debounceDelay = 200;  // Debounce delay in milliseconds

WebSocketsClient webSocket;

// Function to handle WebSocket messages
void webSocketEvent(WStype_t type, uint8_t* payload, size_t length) {
    switch (type) {
        case WStype_CONNECTED:
            Serial.println("[INFO] Connected to WebSocket server");
            break;
        case WStype_TEXT: {
            Serial.printf("[INFO] Received message: %s\n", payload);

            // Parse received JSON
            DynamicJsonDocument doc(256);
            DeserializationError error = deserializeJson(doc, payload);
            if (error) {
                Serial.println("[ERROR] JSON Parsing Failed");
                return;
            }
            JsonArray array = doc.as<JsonArray>();

            // Reset active compartments
            memset(activeCompartments, false, sizeof(activeCompartments));

            // Set compartments from received data
            for (JsonVariant v : array) {
                int index = v.as<int>() - 1;
                if (index >= 0 && index < 4) {
                    activeCompartments[index] = true;
                }
            }
            activateReminder();
            break;
        }
        case WStype_DISCONNECTED:
            Serial.println("[ERROR] Disconnected from WebSocket server");
            break;
    }
}

// Function to activate LED reminders
void activateReminder() {
    ledsOn = true;
    Serial.println("[INFO] Activating Reminder...");
    for (int i = 0; i < 4; i++) {
        if (activeCompartments[i]) {
            digitalWrite(ledPins[i], HIGH);
            Serial.printf("[INFO] LED[%d] ON\n", i + 1);
        }
    }

    // Turn on buzzer for 5 seconds
    digitalWrite(buzzerPin, HIGH);
    delay(5000);
    digitalWrite(buzzerPin, LOW);
    Serial.println("[INFO] Buzzer OFF");
}

// Function to send opened compartments to WebSocket server
void sendOpenedCompartments() {
    DynamicJsonDocument doc(256);
    JsonArray array = doc.to<JsonArray>();

    for (int i = 0; i < 4; i++) {
        if (hallSensorState[i]) {
            array.add(i + 1); // Send compartment index (1-based)
        }
    }

    String jsonString;
    serializeJson(doc, jsonString);
    webSocket.sendTXT(jsonString);

    Serial.printf("[INFO] Sent Opened Compartments: %s\n", jsonString.c_str());
}

// Setup function
void setup() {
    Serial.begin(115200);
    Serial.println("[INFO] Starting ESP32...");

    // Connect to WiFi
    WiFi.begin(ssid, password);
    Serial.print("[INFO] Connecting to WiFi...");
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println("\n[INFO] WiFi Connected");

    // Connect to WebSocket server
    webSocket.begin(ws_server, ws_port, "/");
    webSocket.onEvent(webSocketEvent);

    // Set pin modes
    for (int i = 0; i < 4; i++) {
        pinMode(ledPins[i], OUTPUT);
        pinMode(hallSensorPins[i], INPUT);
        digitalWrite(ledPins[i], LOW); // Ensure all LEDs are initially OFF
    }
    pinMode(buzzerPin, OUTPUT);
    pinMode(buttonPin, INPUT_PULLUP);

    Serial.println("[INFO] System Ready");
}

void loop() {
    webSocket.loop();

    if (ledsOn) {
        // Debug sensor states
        Serial.println("[DEBUG] Checking Hall Sensors:");
        for (int i = 0; i < 4; i++) {
            int hallState = digitalRead(hallSensorPins[i]);
            Serial.printf("[DEBUG] Compartment %d - Hall Sensor: %d | Previous State: %d\n", 
                i + 1, hallState, hallSensorState[i]);

            if (activeCompartments[i]) {
                if (hallState == HIGH && !hallSensorState[i]) {
                    hallSensorState[i] = true; // Mark as opened
                    Serial.printf("[INFO] Lid Opened for Compartment %d\n", i + 1);
                }
            }
        }

        // Check for button press
        if (digitalRead(buttonPin) == LOW) {
            Serial.println("[DEBUG] Button Press Detected!");

            unsigned long currentMillis = millis();
            if (currentMillis - lastButtonPress > debounceDelay) {
                lastButtonPress = currentMillis;
                Serial.println("[INFO] Button Passed Debounce Check");

                // Turn off LEDs only for compartments whose lids were opened
                bool allOff = true;
                for (int i = 0; i < 4; i++) {
                    if (activeCompartments[i] && hallSensorState[i]) {
                        digitalWrite(ledPins[i], LOW);
                        activeCompartments[i] = false;
                        Serial.printf("[INFO] LED[%d] OFF\n", i + 1);
                    }
                    if (activeCompartments[i]) allOff = false;
                }

                if (allOff) {
                    ledsOn = false;
                    Serial.println("[INFO] All LEDs OFF. Reminder completed.");
                }

                // Send opened compartments to the server
                sendOpenedCompartments();
            }

            // Wait for button release to avoid multiple detections
            while (digitalRead(buttonPin) == LOW) {
                Serial.println("[DEBUG] Waiting for Button Release...");
                delay(10);
            }
            Serial.println("[DEBUG] Button Released");
        }
    }
}

