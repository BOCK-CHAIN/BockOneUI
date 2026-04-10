import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Platform-aware API configuration
class ApiConfig {
  ApiConfig._();

  /// Get the base URL for the current platform
  static String get baseUrl {
    // Check for environment variable override first
    final ruvielOverride =
        const String.fromEnvironment('RUVIEL_API_BASE_URL').trim();
    if (ruvielOverride.isNotEmpty) return ruvielOverride;

    final genericOverride = const String.fromEnvironment('API_BASE_URL').trim();
    if (genericOverride.isNotEmpty) return genericOverride;

    // Platform-specific URLs
    if (kIsWeb) {
      return 'http://localhost:3002/api';
    }

    // Android emulator uses 10.0.2.2 to reach host localhost.
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3002/api';
    }

    // Desktop / iOS simulator.
    return 'http://localhost:3002/api';
  }
}
