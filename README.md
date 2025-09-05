# Viajeras Flutter App 🌍
A cross-platform mobile application built with Flutter for connecting travelers worldwide. This project provides multilingual support and features for travel enthusiasts to connect, share experiences, and discover new destinations.

🚀 Features
Multi-language Support: Available in English, Spanish, and Turkish
User Authentication: Complete login/register system with password recovery
Interactive Map: Location-based features for travelers
Profile Management: User profiles with customizable information
Contact Integration: Multiple contact methods including Telegram
Responsive Design: Optimized for all mobile devices
📱 Screenshots
Screenshots will be added here

🛠️ Tech Stack
Framework: Flutter 3.x
Language: Dart
State Management: [To be determined - Provider/Bloc/Riverpod/GetX]
Internationalization: Flutter intl package
Authentication: [To be implemented]
Maps: [To be implemented - Google Maps/MapBox]
Backend: [To be determined]
🌐 Supported Languages
🇺🇸 English
🇪🇸 Español (Spanish)
🇹🇷 Türkçe (Turkish)
📁 Project Structure
lib/
├── l10n/                          # Internationalization files
│   ├── app_localizations.dart
│   ├── app_localizations_en.dart
│   ├── app_localizations_es.dart
│   └── app_localizations_tr.dart
├── localization/                  # Alternative localization approach
│   ├── en_strings.dart
│   ├── es_strings.dart
│   ├── tr_strings.dart
│   └── localization_manager.dart
├── screens/                       # UI screens
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── forgot_password_screen.dart
│   │   └── reset_password_screen.dart
│   ├── map/
│   │   └── map_screen.dart
│   └── errors/
│       └── invalid_token_screen.dart
├── widgets/                       # Reusable widgets
│   └── language_switcher.dart
├── services/                      # Business logic and API calls
├── models/                        # Data models
├── utils/                         # Utility functions
└── main.dart                      # App entry point
🚦 Getting Started
Prerequisites
Flutter SDK (3.x or higher)
Dart SDK (3.x or higher)
Android Studio / VS Code
Android/iOS device or emulator
Installation
Clone the repository
bash
git clone https://github.com/yourusername/viajeras-frontend.git
cd viajeras-frontend
Install dependencies
bash
flutter pub get
Generate localization files (if using Method 1)
bash
flutter gen-l10n
Run the app
bash
flutter run
Configuration
Add your API endpoints in lib/config/api_config.dart
Configure authentication in lib/services/auth_service.dart
Set up maps integration in lib/services/map_service.dart
📝 Available Scripts
flutter run - Run the app in development mode
flutter build apk - Build APK for Android
flutter build ios - Build for iOS
flutter test - Run tests
flutter analyze - Analyze code quality
🌍 Internationalization
This project supports three localization approaches:

Method 1: Flutter Official intl (Recommended)
dart
Text(AppLocalizations.of(context)!.login)
Method 2: Simple Map-based
dart
Text(EnStrings.login)
Method 3: GetX
dart
Text('login'.tr)
Adding New Languages
Create language files following the existing pattern
Add the new locale to LocalizationManager
Update pubspec.yaml if using official intl
Generate localization files
🔧 Development
Code Style
Follow Effective Dart guidelines
Use meaningful variable and function names
Comment complex business logic
Keep widgets small and focused
State Management
To be updated when state management solution is chosen

Testing
bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
📦 Dependencies
Core Dependencies
yaml
dependencies:
flutter:
sdk: flutter
flutter_localizations:
sdk: flutter
intl: any

# Add other dependencies as needed
Dev Dependencies
yaml
dev_dependencies:
flutter_test:
sdk: flutter
flutter_lints: ^2.0.0

# Add testing and development tools
🚀 Deployment
Android
Build APK
bash
flutter build apk --release
Build App Bundle (for Google Play)
bash
flutter build appbundle --release
iOS
Build for iOS
bash
flutter build ios --release
🤝 Contributing
Fork the repository
Create a feature branch (git checkout -b feature/amazing-feature)
Commit your changes (git commit -m 'Add some amazing feature')
Push to the branch (git push origin feature/amazing-feature)
Open a Pull Request
Development Guidelines
Follow the existing code structure
Add tests for new features
Update documentation as needed
Ensure all languages are properly supported
Test on both Android and iOS
🐛 Known Issues
Issues will be tracked here as they are discovered

📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

👥 Team
Project Lead: Viajeras Developer Team
Flutter Developer: Haluk Kılınçer
UI/UX Designer: Serdar Akyol
Backend Developer: Serdar Akyol
📞 Support
Email: chkilincer@gmail.com
Website: https://viajeras.com
Documentation: https://github.com/Erwinya/viajerasfrontend2
🙏 Acknowledgments
Flutter team for the amazing framework
Contributors to the open source libraries used
The travel community for inspiration
📱 Download
App store links will be added when published

Google Play Store //soon
Apple App Store //soon
Made with ❤️ by the Viajeras Developer Team