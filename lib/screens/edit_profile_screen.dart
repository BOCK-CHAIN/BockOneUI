import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trial/widgets/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
//import 'package:date_time_format/date_time_format.dart';

class EditProfileScreen extends StatefulWidget {
  final String username;
  const EditProfileScreen({super.key, required this.username});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();

  Map<String, dynamic> _originalData = {};
  String _enteredUserName = '';
  String _enteredPassword = '';
  String _enteredFirstName = '';
  String _enteredLastName = '';
  String _enteredGender = '';
  String profilePhoto = '';
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

    _loadUserData();
  }

  Future<String> getBaseUrl() async {
    if (kIsWeb) {
      // Accessing from browser (Flutter Web)
      return 'http://192.168.29.176:3000'; // Replace with your PC IP
    }

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.isPhysicalDevice) {
        return 'http://192.168.29.176:3000'; // Real device
      } else {
        return 'http://10.0.2.2:3000'; // Emulator
      }
    } else {
      return 'http://192.168.29.176:3000'; // iOS or web
    }
  }

  Future<void> _loadUserData() async {
    try {
      final baseUrl = await getBaseUrl();
      final url = Uri.parse('$baseUrl/api/profile/${widget.username}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);

        setState(() {
          _originalData = userData;
          _enteredUserName = userData['username'] ?? '';
          _enteredPassword = userData['password'] ?? '';
          _enteredFirstName = userData['first_name'] ?? '';
          _enteredLastName = userData['last_name'] ?? '';
          _enteredGender = userData['gender'] ?? '';
          profilePhoto = userData['profile_photo'] ?? '';
          final rawDob = userData['dob'];
          if (rawDob != null && rawDob.isNotEmpty) {
            try {
              final parsedDob = DateTime.parse(rawDob).toLocal(); // ✅ FIXED
              _dateController.text = DateFormat('d MMM yy').format(parsedDob);
            } catch (e) {
              print("Date parse error: $e");
            }
          }
        });
      } else {
        _showError("User not found!");
      }
    } catch (e) {
      _showError("Failed to fetch data: $e");
    }
  }

  void getImageUrl(File image) {
    imageUrl = image;
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final Map<String, dynamic> updatedFields = {};

    if (_enteredUserName != _originalData['username']) {updatedFields['username'] = _enteredUserName;}
    if (_enteredFirstName != _originalData['first_name']) updatedFields['firstName'] = _enteredFirstName;
    if (_enteredLastName != _originalData['last_name']) updatedFields['lastName'] = _enteredLastName;
    if (_enteredPassword != _originalData['password']) updatedFields['password'] = _enteredPassword;
    if (_enteredGender != _originalData['gender']) updatedFields['gender'] = _enteredGender;
    final originalDobStr = _originalData['dob'];
    DateTime? originalDob = DateTime.tryParse(originalDobStr ?? '');

    if (originalDob == null || _dateController.text != DateFormat('d MMM yy').format(originalDob)) {
      try {
        final parsed = DateFormat('d MMM yy').parse(_dateController.text);
        updatedFields['dob'] = parsed.toIso8601String().split('T').first;
      } catch (e) {
        _showError("Invalid date format. Use format: 24 Jul 25");
        return;
      }
    }


    if (imageUrl != null) {
      const cloudName = 'derbo820u';
      const uploadPreset = 'bockOne';
      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      var request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageUrl!.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final resData = jsonDecode(await response.stream.bytesToString());
        updatedFields['profilePhoto'] = resData['secure_url'];
      }
    }

    if (updatedFields.isNotEmpty) {
      try {
        final baseUrl = await getBaseUrl();
        final url = Uri.parse('$baseUrl/api/profile/${_originalData['username']}');
        final response = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(updatedFields),
        );

        if (response.statusCode == 200) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('loggedInUsername', _enteredUserName);
          Navigator.of(context).pop(_enteredUserName);
        } else {
          _showError("Update failed: ${response.body}");
        }
      } catch (e) {
        _showError("Error updating profile: $e");
      }
    } else {
      Navigator.pop(context); // No changes, just pop
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
    ));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBDFF4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        title: const Text("Edit Your Details", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _originalData.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth > 600 ? 500 : double.infinity,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          "Enter Your Proper Details!",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        ImageInput(getImageUrl: getImageUrl, initialImageUrl: profilePhoto),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: _enteredFirstName,
                                validator: validateName,
                                onSaved: (value) => _enteredFirstName = value!,
                                decoration: _inputDecoration("First Name", Icons.person_outline),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                initialValue: _enteredLastName,
                                validator: validateName,
                                onSaved: (value) => _enteredLastName = value!,
                                decoration: _inputDecoration("Last Name", Icons.person),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          validator: (val) => val == null || val.isEmpty ? "Enter DOB" : null,
                          decoration: _inputDecoration("Date of Birth", Icons.calendar_today),
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime(2005),
                              firstDate: DateTime(1950),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              _dateController.text = DateFormat('d MMM yy').format(pickedDate);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: ['M', 'F'].contains(_enteredGender) ? _enteredGender : null,
                          items: const [
                            DropdownMenuItem(value: 'M', child: Text('Male')),
                            DropdownMenuItem(value: 'F', child: Text('Female')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _enteredGender = value!;
                            });
                          },
                          onSaved: (value) => _enteredGender = value ?? '',
                          validator: (value) => value == null || value.isEmpty ? 'Select Gender' : null,
                          decoration: _inputDecoration("Gender", Icons.wc),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: _enteredUserName,
                          onSaved: (value) => _enteredUserName = value!,
                          decoration: _inputDecoration("Username", Icons.account_circle),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: _enteredPassword,
                          validator: validatePassword,
                          obscureText: true,
                          onSaved: (value) => _enteredPassword = value!,
                          decoration: _inputDecoration("Password", Icons.lock),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9C27B0),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) return "Name can't be empty";
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password can't be empty";
    if (value.length < 6) return "Password must be at least 6 characters";
    return null;
  }
}
