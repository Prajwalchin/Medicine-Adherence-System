# Embedded C Documentation

## Overview
The Embedded C component is an ESP32-based firmware for a smart medication dispenser with LED indicators, hall effect sensors for lid detection, and WebSocket connectivity for real-time communication with the backend server.

## Hardware Components
- **Microcontroller**: ESP32
- **Sensors**: 
  - 4 Hall effect sensors (pins 32, 33, 34, 35) to detect when medication compartment lids are opened
- **Output Devices**:
  - 4 LEDs (pins 2, 4, 5, 18) for visual reminders
  - Buzzer (pin 19) for audible reminders
- **Input Devices**:
  - Button (pin 21) for user interaction

## Connectivity
- **WiFi**: Connects to a configured WiFi network
- **WebSockets**: Establishes a real-time connection with the backend server

## Dependencies
- **WiFi.h**: ESP32 WiFi library
- **WebSocketsClient.h**: WebSocket client library
- **ArduinoJson.h**: JSON parsing and generation library

## Firmware Functionality

### Initialization (setup())
1. Establishes serial communication at 115200 baud
2. Connects to configured WiFi network
3. Initializes WebSocket connection to the backend server
4. Configures GPIO pins for LEDs, hall sensors, buzzer, and button

### Main Loop (loop())
1. Maintains WebSocket connection
2. When medication reminder is active:
   - Monitors hall sensors to detect compartment openings
   - Processes button presses with debouncing
   - Turns off LEDs for compartments that were opened
   - Reports opened compartments to the backend server

### WebSocket Communication
- **Receiving Data**: 
  - Receives an array of active compartment numbers (1-4)
  - Activates corresponding LEDs and buzzer for reminders
- **Sending Data**: 
  - Reports which compartment lids were opened
  - Sends JSON array of opened compartment numbers

### Key Functions
- **webSocketEvent()**: Handles WebSocket events and parses received JSON
- **activateReminder()**: Turns on LEDs for active compartments and buzzer
- **sendOpenedCompartments()**: Reports opened compartments to server
- **setup()**: Initializes hardware and connections
- **loop()**: Main execution loop

## Communication Protocol
- JSON format for data exchange
- Incoming messages format: `[1,2,3,4]` (array of active compartment numbers)
- Outgoing messages format: `[1,3]` (array of opened compartment numbers)

## State Management
- **activeCompartments[]**: Tracks which compartments need medication
- **hallSensorState[]**: Tracks which compartment lids have been opened
- **ledsOn**: Global state for reminder activity

## Debouncing
Button presses are debounced with a 200ms delay to prevent multiple triggers.

## Hardware Circuit Diagram
```
ESP32 ---- LED1 (GPIO2)
      |--- LED2 (GPIO4)
      |--- LED3 (GPIO5)
      |--- LED4 (GPIO18)
      |
      |--- HALL1 (GPIO32)
      |--- HALL2 (GPIO33)
      |--- HALL3 (GPIO34)
      |--- HALL4 (GPIO35)
      |
      |--- BUZZER (GPIO19)
      |--- BUTTON (GPIO21)
```

## Flashing Instructions
1. Install Arduino IDE with ESP32 board support
2. Install required libraries:
   - WiFi
   - WebSocketsClient
   - ArduinoJson
3. Configure WiFi credentials and WebSocket server details
4. Connect ESP32 to computer via USB
5. Select correct board and port in Arduino IDE
6. Upload the firmware

## Troubleshooting
- Serial monitor (115200 baud) provides debugging information
- LED indicators show device state:
  - WiFi connection process
  - WebSocket connection status
  - Reminder activation

## Notes for Developers
- Ensure proper power supply for the ESP32 (3.3V)
- Use pull-up resistors for hall sensors if not using internal pull-ups
- Configure the WebSocket server address before deployment 
