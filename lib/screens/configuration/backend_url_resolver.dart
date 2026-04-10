import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

import 'config.dart';

class BackendUrlResolver {
  BackendUrlResolver._();

  static final RegExp _localhostPattern = RegExp(
    r'^(https?://)(localhost|127\.0\.0\.1)(?=[:/]|$)',
    caseSensitive: false,
  );

  static Future<String> resolve({
    String? configuredBaseUrl,
    int defaultPort = 3000,
  }) async {
    final configured = configuredBaseUrl?.trim() ?? '';
    final baseUrl = configured.isNotEmpty
        ? configured
        : _defaultBaseUrl(defaultPort: defaultPort);

    if (kIsWeb || !Platform.isAndroid) {
      return baseUrl;
    }

    final resolvedHost = await _resolveAndroidHost();
    return _replaceLocalHost(baseUrl, resolvedHost);
  }

  static Future<String> _resolveAndroidHost() async {
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.isPhysicalDevice ? AppConfig.ipAddress : '10.0.2.2';
    } catch (_) {
      // Fall back to the Android emulator loopback bridge when device info
      // is unavailable so localhost-based dev URLs still have a usable host.
      return '10.0.2.2';
    }
  }

  static String _replaceLocalHost(String url, String resolvedHost) {
    final replaced = url.replaceFirstMapped(
      _localhostPattern,
      (match) => '${match.group(1)}$resolvedHost',
    );

    return replaced;
  }

  static String _defaultBaseUrl({required int defaultPort}) {
    if (kIsWeb) {
      return 'http://localhost:$defaultPort';
    }
    return 'http://${AppConfig.ipAddress}:$defaultPort';
  }
}
