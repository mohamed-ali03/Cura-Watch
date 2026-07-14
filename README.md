# Cura-Watch 📱⌚

**Cura-Watch** is a Flutter-based smart healthcare mobile application designed to enable remote patient monitoring and improve communication between patients and doctors.

The application provides two main user interfaces:

- **Patient Application** for monitoring vital signs, viewing medical reports, managing health information, and contacting emergency contacts.
- **Doctor Application** for monitoring assigned patients, reviewing their health history, receiving alerts, and accessing medical reports.

The mobile application communicates with a REST API backend and follows a scalable architecture using **BLoC state management**, **Dio for networking**, **GetIt for dependency injection**, and **SharedPreferences for local session management**.

---

# 🚀 Quick Start

## Requirements

- Flutter SDK (stable version)
- Dart SDK
- Android Studio / VS Code

## Installation

Clone the repository:

```bash
git clone https://github.com/mohamed-ali03/Cura-Watch.git
```

Navigate to the project directory:

```bash
cd Cura-Watch
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

Run on a specific device:

```bash
flutter run -d <deviceId>
```

---

# 📂 Project Structure

```
lib/
│
├── main.dart
│
├── route_generator.dart
│
├── core/
│   ├── api/
│   ├── database/
│   ├── errors/
│   ├── services/
│   ├── widgets/
│   └── constants/
│
└── features/
    │
    ├── auth/
    │   └── AuthBloc
    │
    └── user/
        │
        ├── patient/
        │   ├── Patient UI
        │   ├── PatientBloc
        │   └── Medical Reports
        │
        └── doctor/
            ├── Doctor UI
            ├── DoctorBloc
            └── Patient Monitoring
```

---

# 👥 User Roles

## 🧑 Patient Application

The patient application allows users to monitor their health condition and manage their medical information.

### Authentication

Features include:

- Creating a new account.
- Secure login.
- Session management.

### Patient Profile Management

The patient profile contains:

- Personal information.
- Medical information.
- Blood type.
- Chronic diseases.
- Allergies.
- Medications.
- Emergency contacts.

Patients can update their information through the profile section.

---

## 📊 Patient Dashboard

The dashboard displays the latest patient vital signs:

- ❤️ Heart Rate
- 🩸 Blood Pressure
- 🫁 Oxygen Saturation
- 🚶 Steps
- 🌡 Temperature
- 🩸 Glucose Level

---

## 📈 Vital Reports

Patients can access historical reports for different vital signs:

- Heart Rate.
- Blood Pressure.
- Oxygen Level.
- Steps.
- Temperature.
- Glucose Level.

Reports support:

- Daily reports.
- Weekly reports.
- Monthly reports.
- Custom date selection.

---

## 📞 Emergency Contacts

Patients can quickly communicate with:

- Assigned doctor.
- Emergency contacts.

The application redirects calls to the device phone application.

---

# 👨‍⚕️ Doctor Application

The doctor application provides tools for monitoring assigned patients.

## Patient Monitoring

Doctors can:

- View assigned patients.
- Check current vital readings.
- Review patient information.
- Access complete measurement history.

---

## Medical Reports

Doctors can generate reports for patients:

- Daily reports.
- Weekly reports.
- Monthly reports.
- Custom date reports.

---

## Notifications & Alerts

Doctors receive notifications when abnormal patient readings are detected.

Examples:

- Abnormal heart rate.
- Low oxygen saturation.
- Critical vital measurements.

---

# 🏗 Application Architecture

The application follows a layered architecture:

```
UI Layer
    |
BLoC Layer
    |
Repository Layer
    |
API Service Layer
    |
Backend REST API
```

This architecture provides:

- Separation of responsibilities.
- Maintainable code.
- Scalable development.
- Easier testing.

---

# 🔄 State Management

The application uses the **BLoC (Business Logic Component)** pattern for state management.

## AuthBloc

Responsible for:

- User login.
- User registration.
- Logout.
- Retrieving current user information.

---

## PatientBloc

Responsible for:

- Retrieving patient information.
- Updating personal and medical data.
- Sending new vital measurements.
- Retrieving latest vital readings.
- Editing stored measurements.
- Deleting measurements.
- Generating historical medical reports.

---

## DoctorBloc

Responsible for:

- Doctor profile management.
- Retrieving assigned patients.
- Viewing patient information.
- Accessing patient reports.
- Managing notifications.

---

# 🌐 Networking

The application communicates with the backend using REST APIs.

## Technologies Used:

- Dio HTTP Client.
- Custom API Consumer abstraction.
- API Interceptor.

The interceptor automatically adds the authentication token:

```http
Authorization: Bearer <token>
```

to authenticated requests.

API configuration:

```
lib/core/api/end_points.dart
```

---

# 💾 Local Storage & Session Management

Local data storage is implemented using **SharedPreferences**.

It is used for:

- Authentication token storage.
- User role storage.
- Session persistence.
- Application preferences.

Implementation:

```
lib/core/database/cache/cache_helper.dart
```

---

# 🔌 Dependency Injection

The project uses **GetIt** for dependency injection.

Registered services include:

- CacheHelper.
- DioConsumer.
- SizeConfig.
- RealtimeService.

Configuration:

```
lib/core/services/service_locator.dart
```

Benefits:

- Loose coupling.
- Better code organization.
- Easier testing.

---

# 🎨 UI Components

Reusable UI components are located in:

```
lib/core/widgets/
```

Examples:

- Custom buttons.
- Custom text fields.
- Common UI components.

Responsive design is handled using:

```
lib/core/size_config.dart
```

---

# ⚠️ Error Handling

Network errors are handled using Dio exception handling.

Errors are converted into:

```
ServerException
```

with:

```
ErrorModel
```

This provides consistent error handling throughout the application.

---

# 🧪 Testing & Analysis

Run Flutter tests:

```bash
flutter test
```

Analyze the project:

```bash
flutter analyze
```

---

# 🛠 Technologies Used

## Mobile Development

- Flutter
- Dart

## State Management

- BLoC
- flutter_bloc

## Networking

- Dio
- REST APIs

## Storage

- SharedPreferences

## Architecture

- Clean Architecture Principles
- Dependency Injection
- Repository Pattern

---

# 👨‍💻 Developer

**Mohamed Ali Mohamed**

Flutter Mobile Application Developer

GitHub:

```
https://github.com/mohamed-ali03
```