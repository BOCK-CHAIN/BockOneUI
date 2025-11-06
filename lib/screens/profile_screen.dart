import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trial/screens/auth_screen.dart';
import 'package:trial/screens/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({super.key, required this.username});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
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

  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '';
    try {
      final date = DateTime.parse(isoDate).toLocal();
      return "${date.day} ${_monthName(date.month)} ${date.year % 100}";
    } catch (_) {
      return isoDate;
    }
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }

  Future<void> fetchUserData() async {
    final baseUrl = await getBaseUrl();
    final url =
        Uri.parse('$baseUrl/api/profile/${widget.username}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        userData = jsonDecode(response.body);
      });
    } else {
      print('Failed to fetch profile. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBDFF4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(userData!['username']),
        ),
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () async {
              final updated = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(
                    username: userData!['username'],
                  ),
                ),
              );

              // If username was updated, update widget.username and refetch
              if (updated is String && updated != widget.username) {
                setState(() {
                  userData!['username'] = updated; // update locally
                });
              }

              await fetchUserData();
            },
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator(color: Colors.purple))
          : LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth:
                            constraints.maxWidth > 600 ? 500 : double.infinity,
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.2),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: const Color(0xFFBA68C8),
                                  child: ClipOval(
                                    child: Image.network(
                                      userData!['profile_photo'],
                                      fit: BoxFit.cover,
                                      width: 80,
                                      height: 80,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.person,
                                                  color: Colors.white,
                                                  size: 40),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "${userData!['first_name']} ${userData!['last_name']}",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "@${userData!['username']}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildInfoTile(
                              "User Name", userData!["username"], Icons.person),
                          _buildInfoTile(
                            "Gender",
                            userData!["gender"] == 'M' ? 'Male' : 'Female',
                            userData!["gender"] == 'M'
                                ? Icons.male_outlined
                                : Icons.female_outlined,
                          ),
                          _buildInfoTile(
                            "Date of Birth",
                            _formatDate(userData!["dob"]),
                            Icons.date_range,
                          ),
                          _buildInfoTile("Hex ID", userData!["hex_id"],
                              Icons.info_outline),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.remove('loggedInUsername');
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (_) => const AuthScreen()),
                                  (route) => false,
                                );
                              },
                              icon: const Icon(Icons.logout),
                              label: const Text("Logout"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.purple),
        title: Text(title, style: const TextStyle(color: Colors.black87)),
        subtitle: Text(value, style: const TextStyle(color: Colors.black54)),
        trailing: title == "Hex ID"
            ? IconButton(
                icon: const Icon(Icons.copy, color: Colors.purple),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Hex ID copied to clipboard"),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.deepPurple,
                    ),
                  );
                },
              )
            : null,
      ),
    );
  }
}
