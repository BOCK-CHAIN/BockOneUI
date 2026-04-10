import 'package:flutter/material.dart';
import 'dart:async';
import '../services/auth_service.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _currentAuthState = false;
  bool _isLoading = true;
  late final StreamSubscription<bool> _authSubscription;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
    // Listen to auth state changes
    _authSubscription = AuthService.authStateChanges.listen((isAuth) {
      if (mounted) {
        if (_currentAuthState == isAuth && !_isLoading) return;
        setState(() {
          _currentAuthState = isAuth;
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  Future<void> _checkAuthState() async {
    final isAuth = await AuthService.isAuthenticated();
    if (mounted) {
      setState(() {
        _currentAuthState = isAuth;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    // Return the appropriate screen - NO MaterialApp here!
    return _currentAuthState
        ? const HomeScreen()
        : const LoginScreen();
  }
}
