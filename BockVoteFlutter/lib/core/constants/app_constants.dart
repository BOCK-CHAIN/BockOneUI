/// Application-wide constants
 import 'package:flutter/foundation.dart'
     show TargetPlatform, defaultTargetPlatform, kIsWeb;

class AppConstants {
  // App information
  static const String appName = 'Bockvote';
  static const String appVersion = '1.0.0';

  // API Configuration
  static String get apiBaseUrl {
    final override =
        const String.fromEnvironment('BOCKVOTE_API_BASE_URL').trim();
    if (override.isNotEmpty) return override;

    if (kIsWeb) {
      return 'http://localhost:9000';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:9000';
    }

    return 'http://localhost:9000';
  }
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';

  // Feature Flags
  static const bool enableMockData = true;
  
  // Layout constants
  static const double defaultPadding = 24.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double smallPadding = 16.0;
  static const double largePadding = 32.0;
  
  // Breakpoints for responsive design
  static const double mobileBreakpoint = 767;
  static const double tabletBreakpoint = 1023;
  static const double desktopBreakpoint = 1024;
  
  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 350);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
}
