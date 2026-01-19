# Plant Identifier + Plant Care Companion App

A comprehensive Flutter application that combines AI-powered plant identification with intelligent care management and community features.

## 🌱 Features

### Core Features
- **AI Plant Identification**: Camera-based plant recognition with high accuracy
- **Plant Care Management**: Personalized care schedules and reminders
- **My Garden Collection**: Organize and track your plants
- **Health Diagnostics**: Disease identification and treatment recommendations
- **Expert Guidance**: AI-powered care coaching and tips

### Advanced Features
- **Weather Integration**: Location-based care adjustments
- **Growth Tracking**: Timeline with photos and progress monitoring
- **Community Hub**: Share experiences and learn from other gardeners
- **Safety Database**: Toxicity warnings and allergen information
- **AR Plant Care**: Visual overlay guidance for plant care

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/ShrutiBaviskar0808/Plant-Identifier.git
cd Plant-Identifier
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 📱 App Architecture

The app follows a clean architecture pattern with GetX for state management:

```
lib/
├── app/                 # App-level configuration
├── core/               # Core utilities and services
├── features/           # Feature modules
│   ├── identification/ # Plant identification
│   ├── garden/        # My garden management
│   ├── care/          # Plant care features
│   ├── home/          # Home dashboard
│   └── profile/       # User profile
└── shared/            # Shared components
```

## 🛠️ Tech Stack

- **Framework**: Flutter
- **State Management**: GetX
- **Database**: SQLite (local)
- **AI/ML**: TensorFlow Lite
- **Architecture**: Clean Architecture + MVC
- **Navigation**: GetX Navigation

## 📋 Development Phases

### Phase 1: MVP (Current)
- ✅ Basic plant identification
- ✅ Plant database and profiles
- ✅ User collection management
- ✅ Search and browse system
- ✅ User management

### Phase 2: Care Enhancement
- 🔄 Care reminders and scheduler
- 🔄 Water calculator tools
- 🔄 Health diagnostics
- 🔄 Growth tracking
- 🔄 Educational content

### Phase 3: Advanced Features
- ⏳ AI plant care coach
- ⏳ Weather integration
- ⏳ Safety database
- ⏳ Community features

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Developer**: Shruti Baviskar
- **Project Type**: Plant Care & Identification App

## 📞 Support

For support, email [your-email@example.com] or create an issue in this repository.

## 🙏 Acknowledgments

- Plant identification APIs and datasets
- Flutter community for excellent packages
- Open source contributors

---

**Made with ❤️ for plant lovers everywhere** 🌿