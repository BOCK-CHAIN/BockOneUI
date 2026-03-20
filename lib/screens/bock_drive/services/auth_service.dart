import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'api_service.dart';

class AuthService {
  // Register new user
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final response = await ApiService.post('/auth/register', body: {
        'email': email,
        'password': password,
        if (name != null) 'name': name,
      });

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Save token
        await ApiService.saveToken(data['token']);
        return {
          'success': true,
          'user': data['user'],
          'token': data['token'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      debugPrint('BockDrive register failed: $e | baseUrl=${ApiService.baseUrl}');
      // Hide low-level connection details from the user and show a simple message instead.
      // The full error (including base URL) is still available in the console logs for debugging.
      return {
        'success': false,
        'message': 'Unable to reach the server. Please try again in a moment.',
      };
    }
  }

  // Login user
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post('/auth/login', body: {
        'email': email,
        'password': password,
      });

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Save token
        await ApiService.saveToken(data['token']);
        return {
          'success': true,
          'user': data['user'],
          'token': data['token'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      debugPrint('BockDrive login failed: $e | baseUrl=${ApiService.baseUrl}');
      // Hide low-level connection details from the user and show a simple message instead.
      // The full error (including base URL) is still available in the console logs for debugging.
      return {
        'success': false,
        'message': 'Unable to reach the server. Please try again in a moment.',
      };
    }
  }

  // Get current user
  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await ApiService.get('/auth/me');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'user': data['user'],
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get user',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Logout
  static Future<void> logout() async {
    try {
      await ApiService.post('/auth/logout');
    } catch (e) {
      print('Logout error: $e');
    } finally {
      // Always remove token locally
      await ApiService.removeToken();
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await ApiService.getToken();
    if (token == null) return false;
    
    // Verify token is still valid
    final userResponse = await getCurrentUser();
    return userResponse['success'] == true;
  }

  // Email validation
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Password validation
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }
}
