import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trial/screens/configuration/backend_url_resolver.dart';
import 'package:trial/screens/golligog/config/app_config.dart' as env;
import 'package:trial/screens/krysonix/krysonix_home_screen.dart';

class KrysonixAuthScreen extends StatefulWidget {
  const KrysonixAuthScreen({super.key});

  @override
  State<KrysonixAuthScreen> createState() => _KrysonixAuthScreenState();
}

class _KrysonixAuthScreenState extends State<KrysonixAuthScreen> {
  final _hexIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void authenticate() async {
    if (_isLoading) return;

    final hexId = _hexIdController.text.trim();
    final password = _passwordController.text;
    if (hexId.isEmpty || password.isEmpty) {
      _showError('HexId and password are required');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final backendBaseUrl = await BackendUrlResolver.resolve(
        configuredBaseUrl: env.AppConfig.backendBaseUrl,
        defaultPort: 3000,
      );

      // Call BockOne's krysonixLogin endpoint (validates hexId + password).
      final response = await http.post(
        Uri.parse('$backendBaseUrl/api/auth/krysonixLogin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'hexId': hexId, 'password': password}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode != 200) {
        _showError(responseData['error'] ?? 'Login failed');
        return;
      }

      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => KrysonixHomeScreen(hexId: hexId)),
      );
    } catch (e) {
      _showError('Unable to reach server. Please try again in a moment.');
      debugPrint('Krysonix login error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E1E1E),
              Color(0xFF121212),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              width: screenWidth < 500 ? screenWidth * 0.9 : 400, // responsive width
              decoration: BoxDecoration(
                color: const Color(0xFF202020),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/Krysonix.png',
                    height: 40,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Welcome back! Please Sign in.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Hex - Id",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _hexIdController,
                    cursorColor: Colors.purpleAccent,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF333333),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _passwordController,
                    cursorColor: Colors.purpleAccent,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF333333),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B4BFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _isLoading ? null : authenticate,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
