# 🎯 Community Events App

A comprehensive Flutter application for managing and participating in community events, built with **GetX** state management, **GetWidget** UI components, and **Firebase** backend services.

## ✨ Features

### 🔓 **Guest Mode (No Authentication Required)**
- **Browse Events** - View all community events
- **Search & Filter** - Find events by title, category, or date
- **Event Details** - View complete event information
- **Share Events** - Share event links with others
- **Multi-language Support** - English, Arabic (RTL), Hindi
- **Theme Switching** - Light, Dark, and System themes

### 🔒 **Authenticated Features**
- **RSVP to Events** - Mark as attending/not attending
- **Create Events** - Add new community events with images
- **Edit Events** - Modify events you created
- **Delete Events** - Remove your events
- **My RSVPs** - View events you've RSVPed to
- **User Profile** - Manage account settings and preferences
- **Real-time Updates** - Live synchronization with Firebase

## 🏗️ Architecture

### **Technology Stack**
- **Flutter** - Cross-platform mobile development
- **GetX** - State management, dependency injection, routing
- **GetWidget** - UI component library
- **Firebase** - Backend services (Auth, Firestore, Storage)
- **Google Sign-In** - Authentication provider

### **Project Structure**
```
lib/
├── app/
│   ├── bindings/          # GetX dependency injection
│   ├── controllers/       # Business logic and state management
│   ├── models/           # Data models (AppUser, Event)
│   ├── routes/           # Navigation and routing
│   ├── services/         # Firebase services (Auth, Firestore, Storage)
│   ├── translations/     # Multi-language support
│   └── views/           # UI screens
├── firebase_options.dart # Firebase configuration
└── main.dart            # App entry point
```

### **Key Dependencies**
```yaml
get: ^4.6.5                    # State management
getwidget: ^4.0.0             # UI components
firebase_core: ^2.30.0        # Firebase core
firebase_auth: ^4.17.8        # Authentication
cloud_firestore: ^4.15.8      # Database
firebase_storage: ^11.6.9     # File storage
google_sign_in: ^6.2.1        # Google Sign-In
image_picker: ^1.0.7          # Image selection
url_launcher: ^6.2.5          # External links
get_storage: ^2.1.1           # Local storage
flutter_localizations          # Internationalization
```

## 📱 Screens

### **1. Splash Screen**
- App loading with GetWidget GFLoader
- Authentication state check
- Navigation to Home (Guest Mode) or Login

### **2. Home Screen**
- **Guest Mode**: Browse events, search, filter
- **Authenticated**: Full features with RSVP status
- Tab navigation (All Events, My RSVP, Past Events)
- Pull-to-refresh functionality

### **3. Event Details**
- Complete event information display
- **Guest**: View details, share events
- **Authenticated**: RSVP, edit/delete (if creator)

### **4. Add/Edit Event**
- Form with validation
- Image upload to Firebase Storage
- Category selection
- Date and time picker

### **5. My RSVPs**
- List of user's RSVPed events
- RSVP status with color coding
- Revoke RSVP functionality

### **6. Profile Screen**
- User information display
- Language switching (EN/AR/HI)
- Theme switching (Light/Dark/System)
- Logout functionality

### **7. About/Help**
- App information and features
- FAQ with GetWidget GFAccordion
- Contact links and external resources

## 🚀 Getting Started

### **Prerequisites**
- Flutter SDK (^3.8.1)
- Firebase project setup
- Google Sign-In configuration

### **Installation**

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd community_events_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project
   - Enable Authentication (Google Sign-In)
   - Enable Firestore Database
   - Enable Storage
   - Download and add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)

4. **Run the app**
   ```bash
   flutter run
   ```

### **Firebase Configuration**

1. **Authentication**
   - Enable Google Sign-In in Firebase Console
   - Add SHA-1/SHA-256 fingerprints for Android
   - Configure iOS bundle ID

2. **Firestore Rules**
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /events/{eventId} {
         allow read: if true;
         allow write: if request.auth != null;
         allow update, delete: if request.auth != null && 
           resource.data.createdBy == request.auth.uid;
       }
       match /users/{userId} {
         allow read, write: if request.auth != null && 
           request.auth.uid == userId;
       }
     }
   }
   ```

3. **Storage Rules**
   ```javascript
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       match /events/{allPaths=**} {
         allow read: if true;
         allow write: if request.auth != null;
       }
     }
   }
   ```

## 🌍 Localization

The app supports multiple languages:
- **English** (en_US) - Default
- **Arabic** (ar_SA) - RTL support
- **Hindi** (hi_IN) - Indian language

Language switching is available in the Profile screen.

## 🎨 UI/UX Features

### **GetWidget Components**
- **GFCard** - Event display cards
- **GFButton** - Action buttons with various styles
- **GFAvatar** - User profile pictures
- **GFSearchBar** - Real-time search functionality
- **GFAppBar** - Custom app bars
- **GFAccordion** - FAQ and expandable content
- **GFBadge** - RSVP status indicators
- **GFLoader** - Loading animations

### **Responsive Design**
- Mobile-first approach
- Adaptive layouts for different screen sizes
- Consistent theming across platforms

## 🔧 Development

### **State Management**
- **GetX Controllers** - Business logic and state
- **Reactive Programming** - `.obs` variables and `Obx` widgets
- **Dependency Injection** - `Get.lazyPut` and `Get.find`

### **Navigation**
- **Named Routes** - Clean URL-based navigation
- **Route Guards** - Authentication-based access control
- **Deep Linking** - Direct navigation to specific screens

### **Data Flow**
1. **Firebase Firestore** - Real-time data synchronization
2. **GetX Controllers** - State management and business logic
3. **GetWidget Views** - UI rendering and user interaction
4. **Local Storage** - Persistent user preferences

## 📊 Testing

The app includes comprehensive testing:
- **Unit Tests** - Controller and service testing
- **Widget Tests** - UI component testing
- **Integration Tests** - End-to-end user flows
- **Firebase Testing** - Backend service validation

## 🚀 Deployment

### **Android**
```bash
flutter build apk --release
```

### **iOS**
```bash
flutter build ios --release
```

### **Web**
```bash
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **GetX** for excellent state management
- **GetWidget** for beautiful UI components
- **Firebase** for robust backend services
- **Flutter** team for the amazing framework

---

**Built with ❤️ using Flutter, GetX, and Firebase**
