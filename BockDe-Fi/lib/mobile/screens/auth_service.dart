import 'package:bockchain/mobile/screens/datbase_service.dart';

class AuthService {
  // Login with username or email (returns boolean)
  static Future<bool> login(String usernameOrEmail, String password) async {
    try {
      final user = await DatabaseService.loginUser(
        usernameOrEmail: usernameOrEmail,
        password: password,
      );

      if (user != null) {
        print('Login successful: ${user['username']}');
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Login with details (returns user information)
  static Future<Map<String, dynamic>> loginWithDetails(
    String usernameOrEmail, 
    String password,
  ) async {
    try {
      final user = await DatabaseService.loginUser(
        usernameOrEmail: usernameOrEmail,
        password: password,
      );

      if (user != null) {
        return {
          'success': true,
          'message': 'Login successful',
          'username': user['username'],
          'email': user['email'],
          'userId': user['id'],
        };
      }
      return {
        'success': false,
        'message': 'Invalid credentials. Please check your username/email and password.',
      };
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Register new user
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Validate input
      if (username.length < 3) {
        return {
          'success': false,
          'message': 'Username must be at least 3 characters',
        };
      }

      if (!email.contains('@')) {
        return {
          'success': false,
          'message': 'Invalid email format',
        };
      }

      if (password.length < 6) {
        return {
          'success': false,
          'message': 'Password must be at least 6 characters',
        };
      }

      // Check if username exists
      final usernameExists = await DatabaseService.usernameExists(username);
      if (usernameExists) {
        return {
          'success': false,
          'message': 'Username already taken',
        };
      }

      // Check if email exists
      final emailExists = await DatabaseService.emailExists(email);
      if (emailExists) {
        return {
          'success': false,
          'message': 'Email already registered',
        };
      }

      // Register user
      final success = await DatabaseService.registerUser(
        username: username,
        email: email,
        password: password,
      );

      if (success) {
        return {
          'success': true,
          'message': 'Registration successful',
          'username': username,
          'email': email,
        };
      } else {
        return {
          'success': false,
          'message': 'Registration failed',
        };
      }
    } catch (e) {
      print('Registration error: $e');
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  // Check if user is logged in (implement with shared preferences or state management)
  static Future<bool> isLoggedIn() async {
    // Implement your session management here
    return false;
  }

  // Logout user
  static Future<void> logout() async {
    // Clear user session data
    // Implement with shared preferences or state management
  }
}