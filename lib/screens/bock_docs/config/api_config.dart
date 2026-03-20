import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  // Default configuration
  static const String _defaultLocalUrl = 'http://localhost:5050/api';
  
  // Android emulator must use 10.0.2.2 to access host machine localhost.
  static const String _defaultMobileDevUrl = 'http://10.0.2.2:5050/api';
  
  static String? _customBaseUrl;
  static String? _baseUrl;
  
  // Get the base URL based on platform and environment
  static String get baseUrl {
    if (_baseUrl != null) {
      if (!kIsWeb && Platform.isAndroid) {
        _baseUrl = _normalizeAndroidHost(_baseUrl!);
      }
      return _baseUrl!;
    }
    
    // Check if custom URL is set
    if (_customBaseUrl != null) {
      _baseUrl = _customBaseUrl;
      if (!kIsWeb && Platform.isAndroid) {
        _baseUrl = _normalizeAndroidHost(_baseUrl!);
      }
      return _baseUrl!;
    }
    
    // Platform-specific logic
    if (kIsWeb) {
      // Web: use localhost
      _baseUrl = _defaultLocalUrl;
    } else if (Platform.isIOS) {
      // iOS Simulator: can access localhost directly
      // For physical devices, you may need to use your computer's IP address
      _baseUrl = _defaultLocalUrl; // localhost:5050
    } else if (Platform.isAndroid) {
      // Android: use mobile dev URL (IP address for physical devices)
      // For Android emulator, localhost works but you may need 10.0.2.2
      _baseUrl = _defaultMobileDevUrl;
    } else {
      // Desktop: use localhost
      _baseUrl = _defaultLocalUrl;
    }
    
    return _baseUrl!;
  }

  static String _normalizeAndroidHost(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return url;

    final host = uri.host.toLowerCase();
    if (host == 'localhost' || host == '127.0.0.1') {
      return uri.replace(host: '10.0.2.2').toString();
    }
    return url;
  }
  
  // Set a custom base URL (useful for settings/preferences)
  static Future<void> setBaseUrl(String? url) async {
    _customBaseUrl = url;
    _baseUrl = url;
    
    // Save to preferences for persistence
    if (url != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('api_base_url', url);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('api_base_url');
    }
  }
  
  // Load saved base URL from preferences
  static Future<void> loadSavedBaseUrl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUrl = prefs.getString('api_base_url');
      if (savedUrl != null && savedUrl.isNotEmpty) {
        _customBaseUrl = savedUrl;
        _baseUrl = savedUrl;
      }
    } catch (e) {
      print('Error loading saved base URL: $e');
    }
  }
  
  // Reset to default URL
  static Future<void> resetBaseUrl() async {
    _customBaseUrl = null;
    _baseUrl = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('api_base_url');
  }

  static String? _authToken;
  static String? _userId;

  static String? get userId => _userId;
  static bool get isAuthenticated => _authToken != null;

  static void setAuthToken(String token, int userId) {
    _authToken = token;
    _userId = userId.toString();
  }

  static void clearAuth() {
    _authToken = null;
    _userId = null;
  }

  static Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      if (_authToken != null) 'Authorization': 'Bearer $_authToken',
    };
  }

  // ==================== AUTH ENDPOINTS ====================

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setAuthToken(data['token'], data['user']['id']);
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to sign in');
  }

  static Future<Map<String, dynamic>> signup(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      setAuthToken(data['token'], data['user']['id']);
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to create account');
  }

  static Future<Map<String, dynamic>> googleSignIn(String idToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': idToken}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setAuthToken(data['token'], data['user']['id']);
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to sign in with Google');
  }

  static Future<Map<String, dynamic>> currentUser() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: _getHeaders(),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data['id'] != null) {
        _userId ??= data['id'].toString();
      }
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to load profile');
  }

  static Future<Map<String, dynamic>> updateProfile({String? name, String? email}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/auth/profile'),
      headers: _getHeaders(),
      body: jsonEncode({'name': name, 'email': email}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['user'];
    }

    throw Exception(data['error'] ?? 'Failed to update profile');
  }

  static Future<void> logout() async {
    try {
      await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: _getHeaders(),
      );
    } finally {
      clearAuth();
    }
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      // Check if response is JSON
      if (response.headers['content-type']?.contains('application/json') != true) {
        throw Exception('Server returned non-JSON response. Make sure the backend server is running on port 5050.');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return data;
      }

      throw Exception(data['error'] ?? 'Failed to send password reset email');
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Server connection error. Please ensure the backend server is running on port 5050.');
      }
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> resetPassword(String token, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'newPassword': newPassword}),
      );

      // Check if response is JSON
      if (response.headers['content-type']?.contains('application/json') != true) {
        throw Exception('Server returned non-JSON response. Make sure the backend server is running on port 5050.');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return data;
      }

      throw Exception(data['error'] ?? 'Failed to reset password');
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Server connection error. Please ensure the backend server is running on port 5050.');
      }
      rethrow;
    }
  }

  // ==================== DOCUMENT ENDPOINTS ====================

  static Future<Map<String, dynamic>> createDocument(String title, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/documents/create'),
      headers: _getHeaders(),
      body: jsonEncode({'title': title, 'content': content}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }

    final data = jsonDecode(response.body);
    throw Exception(data['error'] ?? 'Failed to create document');
  }

  static Future<Map<String, dynamic>> getDocument(String docId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/documents/$docId'),
      headers: _getHeaders(),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to load document');
  }

  static Future<List<dynamic>> getUserDocuments() async {
    final response = await http.get(
      Uri.parse('$baseUrl/documents'),
      headers: _getHeaders(),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['error'] ?? 'Failed to load documents');
  }

  static Future<bool> saveDocument(String docId, String title, String content, {String? shareToken}) async {
    final headers = _getHeaders();
    
    // Build request body
    final body = <String, dynamic>{
      'title': title,
      'content': content,
    };
    
    // Add share token if provided (for shared documents)
    if (shareToken != null && shareToken.isNotEmpty) {
      body['shareToken'] = shareToken;
      print('Saving with share token: $shareToken'); // Debug log
    }
    
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/documents/save/$docId'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return true;
      }

      // Try to parse error response
      try {
        final data = jsonDecode(response.body);
        throw Exception(data['error'] ?? 'Failed to save document');
      } catch (e) {
        // If response is not JSON, use the status message
        throw Exception('Failed to save document: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Save document error: $e');
      rethrow;
    }
  }

  static Future<bool> deleteDocument(String docId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/documents/delete/$docId'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return true;
    }

    final data = jsonDecode(response.body);
    throw Exception(data['error'] ?? 'Failed to delete document');
  }

  // ==================== SHARE ENDPOINTS ====================

  static Future<String?> createShareLink(String docId, String permission, int expiresIn) async {
    final response = await http.post(
      Uri.parse('$baseUrl/documents/share/$docId'),
      headers: _getHeaders(),
      body: jsonEncode({'permission': permission, 'expiresIn': expiresIn}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['shareUrl'];
    }

    throw Exception(data['error'] ?? 'Failed to create share link');
  }

  static Future<bool> shareDocumentWithEmail(String docId, String email, String permission) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/documents/share/$docId/email'),
        headers: _getHeaders(),
        body: jsonEncode({
          'email': email.trim(),
          'permission': permission,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data['success'] == true;
      }

      throw Exception(data['error'] ?? 'Failed to share document with email');
    } catch (e) {
      print('Share with email error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getSharedDocument(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/documents/share/$token'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Get shared document error: $e');
      return null;
    }
  }
}
