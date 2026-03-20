import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _newPasswordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    final usersCollection = FirebaseFirestore.instance.collection('users');
    final snapshot = await usersCollection
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      _showSnackbar("Username not found.");
      return;
    }

    final userDoc = snapshot.docs.first.reference;
    await userDoc.update({'password': newPassword});

    _showSnackbar("Password updated successfully!");
    Navigator.pop(context);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.deepPurple,
    ));
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: label,
      hintStyle: const TextStyle(color: Colors.deepPurple),
      prefixIcon: Icon(icon, color: const Color(0xFF7B1FA2)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
    );
  }

  String? _validateField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password can't be empty";
    if (value.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBDFF4),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B1FA2),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter your username and new password",
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _usernameController,
                  validator: _validateField,
                  decoration: _inputDecoration("Username", Icons.person),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _newPasswordController,
                  validator: _validatePassword,
                  obscureText: true,
                  decoration: _inputDecoration("New Password", Icons.lock),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B1FA2),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Update Password",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
