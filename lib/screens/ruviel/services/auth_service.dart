import 'dart:async';
import 'dart:convert';
import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';
import '../models/user_model.dart';
import 'profile_service.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const String _tokenKey = 'ruviel_auth_token';
  static final _authController = StreamController<bool>.broadcast();
  static bool _currentAuthState = false;

  static Future<String> _storeTokenFromResponse(http.Response response, String fallbackMessage) async {
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      if (token != null) {
        await _storage.write(key: _tokenKey, value: token);
        notifyAuthChange(); // Notify listeners
        return token;
      } else {
        throw Exception('No token received');
      }
    }

    final error = jsonDecode(response.body);
    throw Exception(
      error['error'] ?? error['message'] ?? fallbackMessage,
    );
  }

  static Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      return await _storeTokenFromResponse(response, 'Login failed');
    } catch (e) {
      debugPrint('❌ Login error: $e');
      rethrow;
    }
  }

  static Future<String> loginWithHexId(String hexId, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/login-hex'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'hexId': hexId,
          'password': password,
        }),
      );

      return await _storeTokenFromResponse(response, 'Hex ID login failed');
    } catch (e) {
      debugPrint('❌ Hex ID login error: $e');
      rethrow;
    }
  }

  static Future<String> signup(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      return await _storeTokenFromResponse(response, 'Signup failed');
    } catch (e) {
      debugPrint('❌ Signup error: $e');
      rethrow;
    }
  }

  static Future<void> signOut() async {
    try {
      await _storage.delete(key: _tokenKey);
      notifyAuthChange(); // Notify listeners
    } catch (e) {
      debugPrint('❌ Sign out error: $e');
      rethrow;
    }
  }

  static Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      debugPrint('❌ Get token error: $e');
      return null;
    }
  }

  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Stream<bool> get authStateChanges {
    _initializeAuthState();
    return _authController.stream;
  }

  static Future<void> _initializeAuthState() async {
    if (!_authController.isClosed) {
      final isAuth = await isAuthenticated();
      _currentAuthState = isAuth;
      debugPrint('🔐 Initial auth state: $_currentAuthState');
      _authController.add(isAuth);
    }
  }

  static void notifyAuthChange() async {
    if (!_authController.isClosed) {
      // Add small delay to prevent rapid state changes
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Check actual auth state instead of toggling
      final actualAuthState = await isAuthenticated();
      _currentAuthState = actualAuthState;
      debugPrint('🔐 Auth state changed to: $_currentAuthState');
      _authController.add(_currentAuthState);
    }
  }

  static Future<String?> get currentUserId async {
    final token = await getToken();
    if (token == null || token.isEmpty) return null;
    
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      
      String payloadPart = parts[1];
      switch (payloadPart.length % 4) {
        case 1: payloadPart += '==='; break;
        case 2: payloadPart += '=='; break;
        case 3: payloadPart += '='; break;
      }
      
      final payload = jsonDecode(utf8.decode(base64.decode(payloadPart)));
      return payload['id'] as String?;
    } catch (e) {
      debugPrint('Error parsing JWT token: $e');
      return null;
    }
  }

  static String? get currentUserIdSync {
    try {
      // Try to get from cached token synchronously
      // This is a fallback for cases where async is not available
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<void> signIn({required String email, required String password}) async {
    await login(email, password);
  }

  static Future<void> signInWithHexId({
    required String hexId,
    required String password,
  }) async {
    await loginWithHexId(hexId, password);
  }

  static Future<void> signUp({
    required String email,
    required String password,
    required String username,
    String? fullName,
  }) async {
    try {
      await signup(email, password);
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserModel?> getCurrentUserProfile() async {
    return await ProfileService.getCurrentProfile();
  }

  static Future<UserModel?> getUserProfileById(String userId) async {
    return await ProfileService.getUserProfileById(userId);
  }

  static Future<void> updateProfile({
    String? fullName,
    String? bio,
    String? profileImageUrl,
  }) async {
    await ProfileService.updateProfile(
      fullName: fullName,
      bio: bio,
    );
  }

  static Future<String?> uploadProfileImage({
    Uint8List? imageBytes,
    File? imageFile,
  }) async {
    return await ProfileService.uploadProfileImage(
      imageBytes: imageBytes,
      imageFile: imageFile,
    );
  }

  static void dispose() {
    if (!_authController.isClosed) {
      _authController.close();
    }
  }
}
