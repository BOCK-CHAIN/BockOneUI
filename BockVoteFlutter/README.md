# BockVote - Blockchain-Enabled Voting Application

A secure, transparent, and decentralized voting application built with Flutter frontend and blockchain technology for enhanced vote integrity and transparency.

## 🚀 Overview

BockVote is a comprehensive voting platform that combines modern Flutter UI with blockchain technology to ensure secure, transparent, and tamper-proof elections. The application supports multiple platforms (iOS, Android, Web, Desktop) and provides real-time results with blockchain-verified vote integrity.

## ✨ Features

### Core Functionality
- **Secure Authentication**: JWT-based authentication with role-based access control
- **Blockchain Integration**: Custom blockchain implementation for vote verification
- **Real-time Results**: Live election results with WebSocket connections
- **Multi-platform Support**: iOS, Android, Web, and Desktop applications
- **Admin Panel**: Comprehensive election and user management
- **Responsive Design**: Optimized for all screen sizes and devices

### Security Features
- **Blockchain Verification**: All votes are recorded on a custom blockchain
- **Encrypted Storage**: Secure data storage with encryption
- **Audit Trail**: Complete audit logging for all system activities
- **Role-based Access**: Different access levels for voters, admins, and election officials
- **Vote Privacy**: Anonymous voting with verifiable receipts

### User Experience
- **Intuitive Interface**: Clean, modern UI with smooth animations
- **Offline Support**: Limited offline functionality for critical operations
- **Real-time Updates**: Live election results and status updates
- **Vote Confirmation**: Secure vote confirmation with receipt generation
- **Multi-language Support**: Internationalization ready

## 🏗️ Architecture

The application follows a clean architecture pattern with clear separation of concerns:

```
lib/
├── core/                 # Core utilities and configurations
├── data/                 # Data layer (repositories, providers, models)
├── features/             # Feature-based modules
│   ├── admin/           # Admin panel functionality
│   ├── auth/            # Authentication features
│   ├── dashboard/       # User dashboard
│   ├── keys/            # Blockchain key management
│   ├── profile/         # User profile management
│   ├── results/         # Election results
│   └── voting/          # Voting interface
├── presentation/        # UI components and navigation
└── shared/             # Shared utilities and widgets
```

## 🛠️ Technology Stack

### Frontend
- **Flutter**: Cross-platform UI framework
- **Provider**: State management
- **GoRouter**: Navigation and routing
- **Dio**: HTTP client for API communication
- **FL Chart**: Data visualization for results
- **Google Fonts**: Typography
- **Lottie**: Animations

### Backend Integration
- **Custom Blockchain**: Go-based blockchain implementation
- **WebSocket**: Real-time communication
- **REST API**: HTTP-based API communication
- **JWT Authentication**: Secure token-based authentication

### Development Tools
- **Flutter SDK**: ^3.8.1
- **Dart**: Programming language
- **Provider Pattern**: State management
- **Clean Architecture**: Code organization

## 📋 Prerequisites

Before running the application, ensure you have:

- **Flutter SDK**: Version 3.8.1 or higher
- **Dart SDK**: Included with Flutter
- **Android Studio** or **VS Code**: IDE with Flutter extensions
- **Git**: Version control
- **Device/Emulator**: For testing (Android/iOS device or emulator)

### Platform-specific Requirements

#### Android
- Android SDK (API level 21 or higher)
- Android device or emulator

#### iOS
- Xcode 12.0 or higher
- iOS device or simulator
- macOS for iOS development

#### Web
- Chrome browser for testing
- Web server for deployment

## 🚀 Getting Started

### 1. Clone the Repository
```bash
git clone <repository-url>
cd BockVoteFlutter
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure Environment
Create necessary configuration files and ensure all dependencies are properly set up.

### 4. Run the Application
```bash
# For development
flutter run

# For specific platforms
flutter run -d chrome          # Web
flutter run -d android         # Android
flutter run -d ios            # iOS
```

### 5. Build for Production
```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## ���� Configuration

### Environment Setup
The application supports different environments (development, staging, production). Configure the appropriate settings in:

- `lib/core/constants/app_constants.dart`
- Environment-specific configuration files

### Blockchain Integration
The application includes a custom blockchain integration plugin located in:
- `blockchain_integration_plugin/`

Ensure the blockchain backend is running and properly configured before using voting features.

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test files
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage
```

### Test Structure
- **Unit Tests**: Core business logic testing
- **Widget Tests**: UI component testing
- **Integration Tests**: End-to-end functionality testing

### Current Test Status
See `TEST_REPORT.md` for detailed information about resolved issues and current test status.

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android  | ✅ Supported | API level 21+ |
| iOS      | ✅ Supported | iOS 12.0+ |
| Web      | ✅ Supported | Modern browsers |
| Windows  | 🚧 In Development | Desktop support |
| macOS    | 🚧 In Development | Desktop support |
| Linux    | 🚧 In Development | Desktop support |

## 🔐 Security Considerations

### Authentication
- JWT-based authentication with refresh tokens
- Role-based access control (RBAC)
- Secure session management

### Data Protection
- Encrypted data storage
- Secure API communication (HTTPS)
- Blockchain-verified vote integrity
- Audit trail for all operations

### Privacy
- Anonymous voting capabilities
- Data minimization principles
- GDPR compliance considerations

## 📊 Performance

### Optimization Features
- Lazy loading for large datasets
- Efficient state management with Provider
- Optimized image and asset loading
- Responsive design for all screen sizes

### Monitoring
- Real-time performance monitoring
- Error tracking and reporting
- User analytics (privacy-compliant)

## 🤝 Contributing

### Development Workflow
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Standards
- Follow Dart/Flutter style guidelines
- Write comprehensive tests for new features
- Update documentation for significant changes
- Ensure all tests pass before submitting PR

### Issue Reporting
Please use the GitHub issue tracker to report bugs or request features. Include:
- Detailed description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Screenshots (if applicable)
- Device/platform information

## 📚 Documentation

### Additional Resources
- `IMPLEMENTATION_PLAN.md`: Detailed development roadmap
- `TEST_REPORT.md`: Current testing status and resolved issues
- `docs/`: Additional documentation and guides

### API Documentation
API documentation is available for backend integration and blockchain interaction.

## 🚀 Deployment

### Development Deployment
```bash
flutter run --debug
```

### Production Deployment
```bash
# Build for production
flutter build apk --release    # Android
flutter build ios --release    # iOS
flutter build web --release    # Web
```

### CI/CD Pipeline
The project includes automated build and deployment pipelines for:
- Automated testing
- Code quality checks
- Multi-platform builds
- Deployment to staging/production environments

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

### Getting Help
- Check the documentation in the `docs/` folder
- Review existing issues on GitHub
- Create a new issue for bugs or feature requests

### Contact Information
For additional support or questions, please contact the development team through the project's GitHub repository.

## 🔄 Version History

### Current Version: 1.0.0+1
- Initial release with core voting functionality
- Blockchain integration
- Multi-platform support
- Admin panel
- Real-time results

### Upcoming Features
- Enhanced security features
- Advanced analytics
- Mobile-specific optimizations
- Additional language support

---

**Note**: This application is designed for secure voting scenarios and includes blockchain technology for enhanced transparency and integrity. Ensure proper security audits are conducted before deploying in production environments.