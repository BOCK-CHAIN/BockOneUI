import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration service to manage environment variables
class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();

  /// Load environment variables from .env file
  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }

  /// Get backend base URL
  static String get backendBaseUrl {
    return dotenv.env['BACKEND_BASE_URL'] ?? 'http://localhost:5000';
  }

  /// Get SearXNG base URL
  static String get searxngBaseUrl {
    return dotenv.env['SEARXNG_BASE_URL'] ?? 'http://localhost:8080';
  }

  /// Get backend auth URL
  static String get backendAuthUrl => '$backendBaseUrl/api/auth';

  /// Get backend search URL
  static String get backendSearchUrl => '$backendBaseUrl/api/search';
}
