# 🔋 Smart EV Companion App

![Status](https://img.shields.io/badge/Status-Under%20Active%20Development-yellow)
![Platform](https://img.shields.io/badge/Platform-Android-green)
![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)
![License](https://img.shields.io/badge/License-Educational-blue)

**Enhanced Mobile Application for Electric Vehicle Owners**

A Flutter-based mobile companion app for EV owners, providing real-time battery monitoring simulation, nearby charging station discovery, and interactive map visualization. This is an enhanced version of my graduation project, rebuilt with a focus on clean architecture, scalability, and production-ready mobile engineering practices.

---

## 📌 Project Context

This app is an **improved and refactored version** of my graduation project's mobile component. The original project was a complete IoT system combining:
- Custom hardware (ESP32 sensors)
- Machine Learning models for battery health prediction
- Mobile application (Flutter)

🔗 **[View Original Graduation Project →](https://github.com/Abdelrhman20khaled/Predictive-EV-battery-Charging-for-Prolonged-Battery-Life-Public)**

### What's Different in This Version?

**Original Project Focus:**
- Full-stack IoT system (Hardware + ML + Mobile)
- Battery health prediction using ML
- Real ESP32 sensor integration

**Current Version Focus:**
- 🎯 **Mobile-first engineering**
- 🏗️ **Clean Architecture & scalability**
- 🌐 **Real-world API integration** (charging stations)
- 🔄 **Production-ready state management**
- ✨ **Enhanced UX/UI design**

> **Note:** ML components are excluded from this version to focus on demonstrating mobile development expertise. The architecture is designed to easily integrate real hardware data in the future.

---

## 🎯 Problem Statement

Electric vehicle owners face several challenges:
- 📊 Need real-time access to vehicle battery status
- 🔌 Difficulty finding nearby charging stations
- ❓ Lack of detailed information about charging infrastructure (connector types, availability, power output)
- 🗺️ Poor visualization of charging network coverage

**Solution:** A mobile-first application that provides instant access to battery status and comprehensive charging station information with interactive mapping.

---

## ✨ Key Features

### 🔐 Authentication & User Management
- **Firebase Authentication** integration
- Email & Password authentication
- Google Sign-In (OAuth 2.0)
- Secure session management
- User profile handling

### 🔋 Battery Monitoring System
- Real-time battery status visualization
- State of Charge (SoC) display
- State of Health (SoH) indicators
- **Simulated data architecture** (ready for hardware integration)
- Historical data structure (in development)

### 📍 Charging Station Discovery
- **Automatic location detection** using device GPS
- Search radius: **50 km** from current location
- **Real-time charging station data** via EV Charging Stations API
- Station information includes:
  - ✅ Operational status (active/inactive)
  - 🔌 Available connector types (Type 2, CCS, CHAdeMO, etc.)
  - 🔢 Number of charging points
  - ⚡ Power output per connector
  - 📏 Distance calculation from user location

### 🗺️ Interactive Map Visualization
- **OpenStreetMap** integration
- Color-coded station markers:
  - 🟢 Green: Available stations
  - 🔴 Red: Unavailable stations
- Tap markers for detailed station information
- User location marker
- Smooth map interactions and zoom controls
- **Theme support:** Light & Dark modes

### 🎨 User Experience
- Modern, intuitive UI design
- Smooth animations and transitions
- Responsive layouts
- Loading states with shimmer effects
- Error handling with user-friendly messages

---

## 🏗️ Architecture & Technical Design

### Architecture Pattern
- **MVVM (Model-View-ViewModel)** with Repository Pattern
- Clear separation of concerns across layers:
  - **Presentation Layer:** UI components, BLoC/Cubit
  - **Data Layer:** Repositories, data sources, API clients

### State Management
- **BLoC Pattern** for complex state scenarios
- **Cubit** for simpler state management
- Reactive state updates using streams
- Centralized state handling

### Error Handling
- **Functional programming approach** using `Either<Failure, Success>`
- User-friendly error messages
- Network error recovery strategies

### UI State Management
- Comprehensive state handling:
  - 🔄 **Loading State:** Shimmer effects, progress indicators
  - 📭 **Empty State:** Informative empty views
  - ✅ **Success State:** Data display
  - ❌ **Failure State:** Error messages with retry options

### Code Quality
- Clean, readable, and well-documented code
- Modular component structure
- Reusable widgets
- Consistent naming conventions

---

## 🛠️ Tech Stack

### Framework & Language
- **Flutter** (Dart 3.0+)
- Cross-platform ready architecture

### State Management
- **flutter_bloc** - BLoC pattern implementation
- **Cubit** - Simplified state management

### Backend & Authentication
- **Firebase Authentication** - User authentication
- **Firebase Core** - Firebase services initialization
- (Planned) **Cloud Firestore** - Data persistence

### APIs & Services
- **OpenStreetMap** - Map visualization
- **EV Charger API** - Real-time charging data
- **Geolocator** - Location services
- **REST API** integration

### UI & Utilities
- Custom theming (Light/Dark modes)
- Responsive design
- Custom animations

### Architecture & Patterns
- **Either** (dartz) - Functional error handling
- Repository Pattern
- Dependency Injection

---

## 📁 Project Structure
```
lib/
├── core/
│   ├── constants/           # App constants, API keys
│   ├── utils/              # Helpers, extensions
│   ├── widgets/            # Reusable UI components
│   └── theme/              # App theming
│
├── features/
│   ├── auth/
│   │   ├── data/           # Models, data sources, repo impl
│   │   └── presentation/   # UI, BLoC/Cubit, screens
│   │
│   ├── battery/            # Battery monitoring feature
│   ├── charging_stations/  # Charging stations discovery
│   └── map/               # Map visualization
│
└── main.dart
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Android Studio / VS Code
- Firebase account
- API keys for charging station data

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/KarimaMahmoud626/EV-App.git
cd EV-App
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Firebase Setup**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password & Google Sign-In)
   - Download `google-services.json` (Android)
   - Place it in `android/app/`

4. **API Configuration**
   - Obtain API key for EV Charging Stations data
   - Create `lib/core/constants/api_constants.dart`:
```dart
   class ApiConstants {
     static const String chargingStationsApiKey = 'YOUR_API_KEY';
   }
```

5. **Run the app**
```bash
flutter run
```

---

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android | ✅ Supported | Fully tested |
| iOS | 🔄 Planned | Architecture ready, not configured yet |

---

## 📸 Screenshots

### Onboarding & Authentication
| Onboarding | Login |
|:--------:|:---------------:|
| ![Onboarding](assets/screenshots/onboarding.jpeg) | ![Login](assets/screenshots/login.jpeg) |

### Dashboard
| Home Screen 1 | Home Screen 2 |
|:-------------:|:-------------:|
| ![Dashboard](assets/screenshots/home1.jpeg) | ![Dashboard](assets/screenshots/home2.jpeg) |

### Charging Stations
| Map View | Station Details |
|:--------:|:---------------:|
| ![Map](assets/screenshots/map_view.jpeg) | ![Details](assets/screenshots/station_info.jpeg) |

---

## 🚧 Development Status & Roadmap

### ✅ Completed
- [x] Firebase Authentication (Email/Password + Google)
- [x] Battery monitoring simulation
- [x] Charging stations API integration
- [x] Interactive map with OpenStreetMap
- [x] Location-based station discovery
- [x] Clean Architecture implementation
- [x] BLoC state management
- [x] Light/Dark theme support

### 🔄 In Progress
- [ ] Enhanced history & analytics screens
- [ ] UI/UX refinements and animations
- [ ] Firestore integration for data persistence
- [ ] User preferences and settings

### 🔮 Planned Features
- [ ] Advanced filtering (by connector type, power output)
- [ ] Sorting options (by distance, availability)
- [ ] Favorite charging stations
- [ ] Route planning to stations
- [ ] Push notifications for charging status
- [ ] Historical battery data visualization
- [ ] Charging session tracking
- [ ] iOS platform support
- [ ] Widget tests & integration tests
- [ ] CI/CD pipeline

---

## 🎓 Learning Outcomes & Skills Demonstrated

This project showcases:
- ✅ Clean Architecture implementation in Flutter
- ✅ Advanced state management (BLoC/Cubit)
- ✅ Real-world API integration and error handling
- ✅ Firebase services integration
- ✅ Location-based services
- ✅ Map visualization and geospatial data
- ✅ Functional programming concepts (Either pattern)
- ✅ Modern UI/UX design principles
- ✅ Scalable and maintainable code structure

---

## 🔗 Related Projects

- **[Original Graduation Project (Full IoT System)](https://github.com/Abdelrhman20khaled/Predictive-EV-battery-Charging-for-Prolonged-Battery-Life-Public)** - Complete system with hardware, ML, and mobile components
- **[Meal Planning App](https://github.com/KarimaMahmoud626/Meal-Planning-App)** - Another Clean Architecture project with complex features

---

## 👩‍💻 Author

**Karima Mahmoud Mohammed**  
Junior Flutter Developer | Mobile Engineering Enthusiast

- 📧 Email: karimamahmoud382@gmail.com
- 💼 LinkedIn: [Karima Mahmoud](https://www.linkedin.com/in/karima-mahmoud-885077255)
- 🐙 GitHub: [@KarimaMahmoud626](https://github.com/KarimaMahmoud626)

---

## 📄 License

This project is developed for **educational and portfolio purposes**.

---

## 🙏 Acknowledgments

- [Firebase](https://firebase.google.com/) - Authentication and backend services
- [OpenStreetMap](https://www.openstreetmap.org/) - Map visualization
- [Flutter](https://flutter.dev/) - Mobile framework
- Original graduation project team members

---

**⭐ If you find this project interesting or helpful, please consider giving it a star!**

---

## 💬 Feedback

Found a bug or have suggestions? Feel free to open an issue or reach out via [LinkedIn](https://www.linkedin.com/in/karima-mahmoud-885077255)!
