o# 🩺 HealthMobi

An innovative healthcare management system designed to help patients track medication intake, connect with doctors, and maintain a healthier lifestyle.

> **💻 Developed by Gameis Alice Team from PICT College**

## 🌟 Overview

HealthMobi is a comprehensive healthcare platform that bridges the gap between doctors and patients. The application helps users manage their medication courses, receive timely reminders, track medication adherence, and maintain communication with healthcare providers.

## ✨ Key Features

- **🔐 Authentication System**: Secure phone-based OTP authentication
- **💊 Medication Management**: Create and track medicine courses with customizable schedules
- **⏰ Smart Notifications**: Automated reminders for medicine intake
- **📊 Adherence Tracking**: Visual matrix to track medication compliance over time
- **🏥 Doctor-Patient Connection**: Direct communication between doctors and patients
- **📱 Real-time Updates**: WebSocket-based instant notifications and updates
- **🌐 Multi-language Support**: Available in English, Hindi, and Marathi

## 🤝 Interactive Features

- **📲 Medication Intake Confirmation**: Interactive push notifications allow patients to confirm medication intake with a single tap
- **📅 Visual Calendar**: Interactive calendar view showing medication schedule and adherence history
- **🔔 Smart Reminders**: Context-aware notifications that adjust timing based on user behavior patterns
- **💬 Intelligent AI Assistant**: Intuitive AI-powered chat system that allows patients to effortlessly update meal times, medication schedules, and health routines with natural language commands
- **📊 Progress Visualization**: Interactive charts showing adherence trends and health improvements
- **🔄 Sync Across Devices**: Seamless experience across mobile and web platforms

## 🛠️ Technical Architecture

### Backend Components

- **Express Server**: RESTful API endpoints for all app features
- **MySQL Database**: Stores user data, medication courses, and intake records
- **WebSockets**: Real-time communication for notifications and updates
- **Cron Jobs**: Scheduled tasks for medication reminders and daily quote refreshing
- **Twilio Integration**: SMS-based OTP verification and notifications

### Frontend Components

- **React Native**: Cross-platform mobile application
- **Modern UI/UX**: Intuitive user interface for all features
- **Local Storage**: Caching for offline functionality
- **Push Notifications**: Real-time alerts for medication reminders

### Embedded Systems

- **IoT Integration**: Support for smart medication pill box 
- **Health Monitoring**: Integration with health tracking devices

### Database Schema

The application uses a relational database with tables for:

- Users (patients and doctors)
- Authentication tokens
- Medication courses
- Medicine intakes
- Prescription media (images and voice notes)
- Daily motivational quotes

## 🚀 Getting Started

### Prerequisites

- Node.js (v14+)
- MySQL Server
- Twilio Account (for SMS features)
- Cloudinary Account (for media storage)

### Backend Installation

1. Navigate to the Backend directory
2. Install dependencies:
   ```
   npm install
   ```
3. Set up your environment variables in `.env`
4. Initialize the database using `main.sql`
5. Start the server:
   ```
   npm start
   ```

### Frontend Installation

1. Navigate to the Frontend directory
2. Install dependencies
3. Configure the app to connect to your backend
4. Run the development server

## 📱 Mobile Client

The mobile application provides:

- User-friendly medication tracking interface
- Reminders and notifications
- Doctor communication tools
- Health insights and analytics

## 💡 Unique Features

- **Quote of the Day**: Daily motivational health quotes in the user's preferred language
- **Visual Medication Adherence**: Intuitive matrix display showing medication compliance
- **Voice Prescription Notes**: Doctors can record voice notes with prescription instructions
- **Custom User Notes**: Personal health notes for patients to track symptoms and progress

## 🔒 Security Features

- Token-based authentication
- Secure OTP verification
- Role-based access control
- Encrypted sensitive data

## 🌈 Future Roadmap

- AI-powered health insights
- Telemedicine video consultations
- Integration with wearable health devices
- Expanded language support

## 🌍 Open Source Initiative

HealthMobi is planning to transition to an open source model to foster innovation and collaboration in healthcare technology. Our mission is to make quality healthcare management accessible to everyone.

## 🧩 Integration Opportunities

- **Health Wearables**: API hooks for smartwatches and fitness trackers
- **EHR Systems**: Integration with electronic health record systems
- **Pharmacy Networks**: Direct connection with medical systems
- **Telehealth Platforms**: API for video consultation integration


# AI - Model

The Prescription is trascribed and AI will generate the schedule.


![WhatsApp Image 2025-01-04 at 9 37 59 AM (1)](https://github.com/user-attachments/assets/e68ba7a1-830e-480d-a157-bdb2e4ef495a)








# Smart Pillbox 


A Smart pillbox prototype featuring an ESP32 microcontroller, TCRT5000 sensors for pill detection, and LEDs for visual alerts. It integrates with mobile apps and wearables to provide real-time medication tracking, reminders, and adherence monitoring.




![WhatsApp Image 2025-01-04 at 10 39 27 AM (1)](https://github.com/user-attachments/assets/aeacded5-12e9-4e21-a7d0-41f0e17ef3a3)




![WhatsApp Image 2025-01-04 at 10 39 28 AM (3)](https://github.com/user-attachments/assets/0aabf944-0806-465a-8b30-81fd228fc3f6)


![WhatsApp Image 2025-01-04 at 10 39 28 AM (4)](https://github.com/user-attachments/assets/a7f0a8ab-fee3-4154-be23-b118fe0e6c25)












# Patient Site App UI

Mobile app interface for the Medication Adherence System, featuring a daily schedule with time-specific slots (morning, afternoon, evening, night), a calendar for date selection, a detailed medication list with dosage and checkboxes for tracking, reminders via a bell icon, and a note-taking section for user observations. It simplifies medication management and promotes adherence.

![WhatsApp Image 2025-01-04 at 10 37 14 AM](https://github.com/user-attachments/assets/f38a52b3-f291-48a7-8d25-413e166d317f)





# Doctor's Dashboard

This Doctor's Dashboard provides an overview of patient management metrics, including total patients, average adherence, critical alerts, and pending reviews, along with a line chart displaying patient adherence trends over time. It is designed to help doctors monitor adherence and address critical issues efficiently.

![WhatsApp Image 2025-01-04 at 10 48 07 AM](https://github.com/user-attachments/assets/3ccd37d4-320c-4ef6-9451-246636102c07)


![WhatsApp Image 2025-01-04 at 10 48 11 AM (1)](https://github.com/user-attachments/assets/18d3eb9d-ec03-484c-bede-095f6abfd692)


