import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../../configuration/backend_url_resolver.dart';

class BockFoodsAuthService {
  static const _tokenKey = 'bockFoodsAuthToken';
  static const _userKey = 'bockFoodsUser';

  /// Login using BockOne credentials (username/password)
  /// Falls back to BockFoodsServer if BOCK_FOODS_API_BASE_URL is set
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      // Check if custom API base URL is set (BockFoodsServer)
      final foodsBaseUrl = ApiConfig.baseUrl;
      
      if (foodsBaseUrl != null && foodsBaseUrl.trim().isNotEmpty) {
        // Use BockFoodsServer login (email/password)
        return await _loginToFoodsServer(
          email: username, // Treat username as email for Foods server
          password: password,
          baseUrl: foodsBaseUrl,
        );
      }

      // Default: Use BockOne login endpoint
      return await _loginToBockOne(
        username: username,
        password: password,
      );
    } catch (e) {
      return {
        'success': false,
        'message': 'Unable to reach the server. Please try again.',
      };
    }
  }

  /// Login to BockOne backend (username/password)
  static Future<Map<String, dynamic>> _loginToBockOne({
    required String username,
    required String password,
  }) async {
    // Get BockOne backend URL from environment or default
    final baseUrl = await _getBockOneBaseUrl();
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // BockOne returns: { message: 'Login successful', user: {...} }
      // No token in BockOne response, so we'll use a placeholder
      final user = data['user'] ?? {'username': username};
      final token = data['token'] ?? 'bockone_${username}_${DateTime.now().millisecondsSinceEpoch}';
      
      await _saveAuth(token, user);
      
      return {
        'success': true,
        'token': token,
        'user': user,
      };
    } else {
      return {
        'success': false,
        'message': data['error'] ?? data['message'] ?? 'Login failed',
      };
    }
  }

  /// Login to BockFoodsServer (email/password with Prisma)
  static Future<Map<String, dynamic>> _loginToFoodsServer({
    required String email,
    required String password,
    required String baseUrl,
  }) async {
    final uri = Uri.parse(baseUrl).replace(
      path: '${Uri.parse(baseUrl).path.replaceAll(RegExp(r"/+$"), "")}/api/auth/login',
    );

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final token = data['token'] ?? '';
      final user = data['user'] ?? {'email': email};
      
      await _saveAuth(token, user);
      
      return {
        'success': true,
        'token': token,
        'user': user,
      };
    } else {
      return {
        'success': false,
        'message': data['message'] ?? data['error'] ?? 'Login failed',
      };
    }
  }

  /// Get BockOne backend base URL
  static Future<String> _getBockOneBaseUrl() {
    return BackendUrlResolver.resolve(
      configuredBaseUrl: 'http://localhost:3000',
      defaultPort: 3000,
    );
  }

  /// Save authentication token and user info
  static Future<void> _saveAuth(String token, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user));
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Get current auth token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Get current user info
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(_userKey);
    if (userStr == null) return null;
    try {
      return jsonDecode(userStr) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  /// Get authorization headers for API requests
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }
}
