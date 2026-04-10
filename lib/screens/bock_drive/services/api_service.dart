import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // Optional runtime override:
  // flutter run --dart-define=BOCK_DRIVE_API_BASE_URL=http://192.168.0.109:3001/api
  static const String _overrideBaseUrl =
      String.fromEnvironment('BOCK_DRIVE_API_BASE_URL');

  static String get baseUrl {
    if (_overrideBaseUrl.trim().isNotEmpty) {
      return _overrideBaseUrl.trim();
    }

    if (kIsWeb) {
      return 'http://localhost:3001/api';
    }

    // Android emulator needs 10.0.2.2 to reach host machine localhost.
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3001/api';
    }

    // Desktop / iOS simulator default.
    return 'http://localhost:3001/api';
  }
  
  // Get stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Remove token (logout)
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Get headers with authentication
  static Future<Map<String, String>> getHeaders({Map<String, String>? additionalHeaders}) async {
    final token = await getToken();
    final headers = {
      'Content-Type': 'application/json',
      ...?additionalHeaders,
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  // GET request
  static Future<http.Response> get(String endpoint, {Map<String, String>? queryParams}) async {
    try {
      final headers = await getHeaders();
      var uri = Uri.parse('$baseUrl$endpoint');
      
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }
      
      return await http.get(uri, headers: headers).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout. Make sure the backend server is running at $baseUrl');
        },
      );
    } catch (e) {
      throw Exception('Failed to connect to server at $baseUrl$endpoint. Error: $e');
    }
  }

  // POST request
  static Future<http.Response> post(String endpoint, {Map<String, dynamic>? body, Map<String, String>? additionalHeaders}) async {
    try {
      final headers = await getHeaders(additionalHeaders: additionalHeaders);
      final uri = Uri.parse('$baseUrl$endpoint');
      
      return await http.post(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout. Make sure the backend server is running at $baseUrl');
        },
      );
    } catch (e) {
      throw Exception('Failed to connect to server at $baseUrl$endpoint. Error: $e');
    }
  }

  // PATCH request
  static Future<http.Response> patch(String endpoint, {Map<String, dynamic>? body}) async {
    final headers = await getHeaders();
    final uri = Uri.parse('$baseUrl$endpoint');
    
    return await http.patch(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  // DELETE request
  static Future<http.Response> delete(String endpoint) async {
    final headers = await getHeaders();
    final uri = Uri.parse('$baseUrl$endpoint');
    
    return await http.delete(uri, headers: headers);
  }

  // Multipart request for file upload
  static Future<http.StreamedResponse> postMultipart(
    String endpoint, {
    required Map<String, String> fields,
    required List<http.MultipartFile> files,
  }) async {
    final token = await getToken();
    final uri = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('POST', uri);
    
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    
    request.fields.addAll(fields);
    request.files.addAll(files);
    
    return await request.send();
  }
}

