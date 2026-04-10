import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapsApiConfig {
  MapsApiConfig._();

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

  static String _trimTrailingSlash(String url) =>
      url.endsWith('/') ? url.substring(0, url.length - 1) : url;

  static String get backendBaseUrl {
    final configured = dotenv.env['BACKEND_URL'] ?? 'http://localhost:3001';
    return _trimTrailingSlash(_normalizeAndroidLocalhost(configured));
  }
}
