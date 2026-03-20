import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

import 'config.dart';

class BackendUrlResolver {
  BackendUrlResolver._();

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

    final uri = Uri.tryParse(baseUrl);
    if (uri == null) {
      return baseUrl;
    }

    final host = uri.host.toLowerCase();
    final isLocalHost = host == 'localhost' || host == '127.0.0.1';
    if (!isLocalHost) {
      return baseUrl;
    }

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final resolvedHost = androidInfo.isPhysicalDevice
        ? AppConfig.ipAddress
        : '10.0.2.2';

    return uri.replace(host: resolvedHost).toString();
  }

  static String _defaultBaseUrl({required int defaultPort}) {
    if (kIsWeb) {
      return 'http://localhost:$defaultPort';
    }
    return 'http://${AppConfig.ipAddress}:$defaultPort';
  }
}
