# Frontend Documentation

## Overview
The Frontend component is a Flutter-based mobile application named "healthmobi" that provides a healthcare/medication tracking interface. The application is built using Flutter SDK with Dart programming language.

## Technology Stack
- **Framework**: Flutter
- **Language**: Dart
- **Flutter SDK Version**: ^3.6.0
- **State Management**: flutter_riverpod (^2.6.1)

## Key Dependencies
- **UI/Design**:
  - google_fonts (^6.2.1)
  - resize (^1.0.0)
  - progress_border (^0.1.5)
  - speedometer_chart (^1.0.8)
  - shimmer (^3.0.0)
  - flutter_markdown (^0.7.6+2)

- **Networking/Communication**:
  - http (^1.3.0)
  - socket_io_client (^3.0.2)

- **Device Features**:
  - image_picker (^1.1.2)
  - camera (^0.11.1)

- **Authentication/Input**:
  - flutter_otp_text_field (^1.5.1+1)
  - intl_phone_number_input (^0.7.4)

- **Data Persistence**:
  - shared_preferences (^2.5.1)

## Project Structure
The application follows the standard Flutter project structure with:
- `lib/`: Contains the main Dart source code
- `assets/`: Contains images and other static resources
- `android/`: Android-specific configuration
- `pubspec.yaml`: Dependency and configuration file

## Building & Running
1. Ensure Flutter SDK (^3.6.0) is installed
2. Run `flutter pub get` to download dependencies
3. Connect a device or emulator
4. Run `flutter run` to start the application

## Key Features
- User authentication with OTP verification
- Medication tracking interface
- Real-time communication with backend using WebSockets
- Camera integration for image capture
- Health metrics visualization with charts

## Architecture
The application appears to use Riverpod for state management, suggesting a component-based architecture with separation of UI, business logic, and data layers.

## WebSocket Communication
The app uses socket_io_client to establish real-time communication with the backend server, likely for receiving medication reminders and sending compartment status.

## Notes for Developers
- The project uses Material Design
- Custom assets should be placed in the assets/images/ directory
- The codebase follows Flutter's recommended linting rules (flutter_lints package) 
