import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Configuration service to manage environment variables
class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();

  /// Load environment variables from .env file
  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }

  static const String _backendOverride =
      String.fromEnvironment('GOLLIGOG_BACKEND_BASE_URL');
  static const String _searxngOverride =
      String.fromEnvironment('GOLLIGOG_SEARXNG_BASE_URL');

  static String _normalizeAndroidLocalhost(String url) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return url;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) return url;

    final host = uri.host.toLowerCase();
    if (host == 'localhost' || host == '127.0.0.1') {
      return uri.replace(host: '10.0.2.2').toString();
    }

    return url;
  }

  /// Get backend base URL
  static String get backendBaseUrl {
    // Priority: dart-define override > .env > hardcoded fallback.
    final configured = _backendOverride.trim().isNotEmpty
        ? _backendOverride
        : (dotenv.env['BACKEND_BASE_URL'] ?? 'http://localhost:3000');

    return _normalizeAndroidLocalhost(configured);
  }

  /// Get SearXNG base URL
  static String get searxngBaseUrl {
    // Priority: dart-define override > .env > hardcoded fallback.
    final configured = _searxngOverride.trim().isNotEmpty
        ? _searxngOverride
        : (dotenv.env['SEARXNG_BASE_URL'] ?? 'http://localhost:8080');

    return _normalizeAndroidLocalhost(configured);
  }

  /// Get backend auth URL
  static String get backendAuthUrl => '$backendBaseUrl/api/auth';

  /// Get backend search URL
  static String get backendSearchUrl => '$backendBaseUrl/api/search';
}
