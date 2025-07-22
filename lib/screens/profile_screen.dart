import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
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

  Future<void> fetchUserData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: widget.username)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        userData = snapshot.docs.first.data();
      });
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(
                    username: userData!['username'],
                  ),
                ),
              );
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
                  maxWidth: constraints.maxWidth > 600 ? 500 : double.infinity,
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
                                userData!['profilePhoto'],
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.person, color: Colors.white, size: 40),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${userData!['firstName']} ${userData!['lastName']}",
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
                    _buildInfoTile("User Name", userData!["username"], Icons.person),
                    _buildInfoTile(
                      "Gender",
                      userData!["gender"]== 'M' ? 'Male':'Female',
                      userData!["gender"] == 'M' ? Icons.male_outlined : Icons.female_outlined,
                    ),
                    _buildInfoTile("Date of Birth", userData!["DOB"], Icons.date_range),
                    _buildInfoTile("Hex ID", userData!["hexId"], Icons.info_outline),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('loggedInUsername');
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const AuthScreen()),
                                (route) => false,
                          );
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text("Logout"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
