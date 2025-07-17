import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trial/widgets/image_picker.dart';
import 'package:trial/services/generating_hex_id.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:trial/screens/forgot_password_screen.dart';
import 'package:trial/screens/home_screen.dart';


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

  void authenticate() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final usersCollection = FirebaseFirestore.instance.collection('users');

    if (isLogin) {
      // 🔒 LOGIN
      final snapshot = await usersCollection
          .where('username', isEqualTo: _enteredUserName)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        _showError('Username does not exist.');
        return;
      }

      final userData = snapshot.docs.first.data();
      if (userData['password'] != _enteredPassword) {
        _showError('Incorrect password.');
        return;
      }

      // ✅ Save login info
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('loggedInUsername', _enteredUserName);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => HomeScreen(userName: _enteredUserName,)),
      );
    } else {
      // 📝 SIGNUP

      if (imageUrl == null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload an image before submitting.')),
        );
        return;
      }
      const cloudName = 'derbo820u';
      const uploadPreset = 'bockOne';

      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      var request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageUrl!.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final resStream = await response.stream.bytesToString();
        final resData = jsonDecode(resStream);
        //print(resData['secure_url']);// This is the public link!

        profilePhoto=resData['secure_url'];
      } else {
        //print('Failed to upload: ${response.statusCode}');
      }

      final snapshot = await usersCollection
          .where('username', isEqualTo: _enteredUserName)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _showError('Username already exists. Choose another.');
        return;
      }

      String hexId = generateHexId(_enteredUserName, _enteredPassword, _enteredFirstName, _enteredLastName, _dateController.text, _enteredGender);

      await usersCollection.add({
        'username': _enteredUserName,
        'password': _enteredPassword,
        'firstName': _enteredFirstName,
        'lastName': _enteredLastName,
        'DOB':_dateController.text,
        'gender':_enteredGender,
        'hexId': hexId,
        'profilePhoto':profilePhoto,
        'createdAt': Timestamp.now(),
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('loggedInUsername', _enteredUserName);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => HomeScreen(userName: _enteredUserName,)),
      );
    }

    /*try {
      if (isLogin) {
        await _firebase.signInWithEmailAndPassword(
            email: _enteredEmailID, password: _enteredPassword);
      } else {
        final userCredential = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmailID,
          password: _enteredPassword,
        );

        final uid = userCredential.user?.uid;
        String hexId = generateHexId(_enteredEmailID, _enteredPassword);
        await FirebaseFirestore.instance.collection("users").add({
          "firstName": _enteredFirstName,
          "LastName": _enteredLastName,
          "Email ID": _enteredEmailID,
          "HexId": hexId,
          "uid": uid,
        });
      }
      if (!mounted) return;
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? "Authentication Failed")),
      );
    }*/
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
    ));
  }

  /*String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email can't be empty";
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return "Enter a valid email";
    return null;
  }*/

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
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter Gender';
                      if (value != 'M' && value != 'F') return 'Enter M or F';
                      return null;
                    },
                    decoration: _inputDecoration("Gender (M / F)", Icons.wc),
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
