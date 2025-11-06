import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trial/widgets/image_picker.dart';
import 'package:trial/services/generating_hex_id.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:trial/screens/forgot_password_screen.dart';
import 'package:trial/screens/home_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController =TextEditingController();
  String _enteredUserName = '';
  String _enteredPassword = '';
  String _enteredFirstName = '';
  String _enteredLastName = '';
  String _enteredGender = '';
  String profilePhoto='';
  File? imageUrl;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void toggleAuthMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void getImageUrl(File image)
  {
    imageUrl=image;
  }

  Future<String> getBaseUrl() async {
    if (kIsWeb) {
      // Accessing from browser (Flutter Web)
      return 'http://13.233.163.28:3000'; // Replace with your PC IP
    }

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.isPhysicalDevice) {
        return 'http://13.233.163.28:3000'; // Real device
      } else {
        return 'http://13.233.163.28:3000'; // Emulator
      }
    } else {
      return 'http://13.233.163.28:3000'; // iOS or web
    }
  }

  void authenticate() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final baseUrl = await getBaseUrl();
    final apiUrl = isLogin
        ? '$baseUrl/api/auth/login'
        : '$baseUrl/api/auth/signup';

    String profilePhotoUrl = '';

    if (!isLogin) {
      if (imageUrl == null) {
        _showError('Please upload an image.');
        return;
      }

      final uploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/auth/upload-photo'),
      )
        ..files.add(
            await http.MultipartFile.fromPath('profilePhoto', imageUrl!.path));

      final uploadResponse = await uploadRequest.send();
      final uploadResStr = await uploadResponse.stream.bytesToString();
      final uploadResData = jsonDecode(uploadResStr);

      if (uploadResponse.statusCode != 200) {
        _showError(uploadResData['error'] ?? 'Image upload failed');
        return;
      }

      profilePhotoUrl = uploadResData['imageUrl'];
    }

    final requestBody = isLogin
        ? {
      'username': _enteredUserName,
      'password': _enteredPassword,
    }
        : {
      'username': _enteredUserName,
      'password': _enteredPassword,
      'firstName': _enteredFirstName,
      'lastName': _enteredLastName,
      'dob': _dateController.text,
      'gender': _enteredGender,
      'hexId': generateHexId(
          _enteredUserName, _enteredPassword, _enteredFirstName, _enteredLastName, _dateController.text, _enteredGender),
      'profilePhoto': profilePhotoUrl,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode != 200 && response.statusCode != 201) {
      _showError(responseData['error'] ?? 'Something went wrong');
      return;
    }

    // Save to shared prefs
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedInUsername', _enteredUserName);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomeScreen(userName: _enteredUserName)),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
    ));
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password can't be empty";
    if (value.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) return "Full Name can't be empty";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBDFF4),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    isLogin ? "Welcome Back!" : "Create Your Account",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A1B9A),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    isLogin
                        ? "Login to BOCK ONE"
                        : "Join BOCK ONE today!",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                if (!isLogin) ImageInput(getImageUrl: getImageUrl),
                if (!isLogin) const SizedBox(height: 20),

                if (!isLogin)
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: validateName,
                          keyboardType: TextInputType.name,
                          decoration: _inputDecoration("First Name", Icons.person_outline),
                          onSaved: (value) => _enteredFirstName = value!,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          validator: validateName,
                          keyboardType: TextInputType.name,
                          decoration: _inputDecoration("Last Name", Icons.person),
                          onSaved: (value) => _enteredLastName = value!,
                        ),
                      ),
                    ],
                  ),

                if (!isLogin) const SizedBox(height: 20),

                if (!isLogin)
                  TextFormField(
                    controller: _dateController,
                    validator: (val) => val == null || val.isEmpty ? "Enter DOB" : null,
                    readOnly: true,
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2005),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        _dateController.text = pickedDate.format('j M y');
                      }
                    },
                    decoration: _inputDecoration("Date of Birth", Icons.calendar_today),
                  ),

                if (!isLogin) const SizedBox(height: 20),

                if (!isLogin)
                  DropdownButtonFormField<String>(
                    value: _enteredGender.isEmpty ? null : _enteredGender,
                    decoration: _inputDecoration("Gender", Icons.wc),
                    items: const [
                      DropdownMenuItem(value: 'M', child: Text('Male')),
                      DropdownMenuItem(value: 'F', child: Text('Female')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _enteredGender = value!;
                      });
                    },
                    validator: (value) => value == null || value.isEmpty ? 'Select Gender' : null,
                    onSaved: (value) => _enteredGender = value!,
                  ),

                const SizedBox(height: 20),

                TextFormField(
                  validator: (val) => val!.length < 4 ? "Min 4 chars" : null,
                  decoration: _inputDecoration("Username", Icons.account_circle),
                  onSaved: (value) => _enteredUserName = value!,
                ),

                const SizedBox(height: 20),

                TextFormField(
                  validator: validatePassword,
                  obscureText: true,
                  decoration: _inputDecoration("Password", Icons.lock),
                  onSaved: (value) => _enteredPassword = value!,
                ),

                if (isLogin)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Color(0xFF7B1FA2)),
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authenticate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9C27B0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      isLogin ? "Login" : "Sign Up",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: TextButton(
                    onPressed: toggleAuthMode,
                    child: Text(
                      isLogin
                          ? "Don't have an account? Sign Up"
                          : "Already have an account? Login",
                      style: const TextStyle(
                        color: Color(0xFF6A1B9A),
                        fontWeight: FontWeight.bold,
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

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: label,
      hintStyle: const TextStyle(color: Colors.deepPurple),
      prefixIcon: Icon(icon, color: const Color(0xFF9C27B0)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
    );
  }

}
