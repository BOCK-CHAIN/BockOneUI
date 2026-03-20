import 'package:flutter/material.dart';

class ProfileEditScreen extends StatelessWidget {
  final bool isSettings;
  final bool isWeb;
  const ProfileEditScreen({super.key,required this.isSettings,required this.isWeb});

  @override
  Widget build(BuildContext context) {
    return isWeb ? Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover photo placeholder
              Container(
                height: 120,
                width: double.infinity,
                color: const Color(0xFF2C2C2C),
              ),

              // Profile avatar + name
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white, size: 40),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "likith",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),

              // ==== Personal Info Section ====
              _buildSection(
                title: "Personal Info",
                children: [
                  _buildTextField(label: "Name", initialValue: "likith"),
                  _buildTextField(
                    label: "Email address",
                    initialValue: "abcdef@gmail.com",
                    enabled: false,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ==== Profile Section ====
              _buildSection(
                title: "Profile",
                children: [
                  _buildTextField(label: "Handle", initialValue: ""),
                  _buildTextArea(
                    label: "About",
                    hint: "Write a few sentences about yourself.",
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        isWeb?null:Navigator.of(context).pop();
                        isWeb?null:isSettings?Navigator.of(context).pop():null;
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ):
    Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset('assets/images/Krysonix.png', height: 50),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover photo placeholder
              Container(
                height: 120,
                width: double.infinity,
                color: const Color(0xFF2C2C2C),
              ),

              // Profile avatar + name
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white, size: 40),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "likith",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),

              // ==== Personal Info Section ====
              _buildSection(
                title: "Personal Info",
                children: [
                  _buildTextField(label: "Name", initialValue: "likith"),
                  _buildTextField(
                    label: "Email address",
                    initialValue: "abcdef@gmail.com",
                    enabled: false,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ==== Profile Section ====
              _buildSection(
                title: "Profile",
                children: [
                  _buildTextField(label: "Handle", initialValue: ""),
                  _buildTextArea(
                    label: "About",
                    hint: "Write a few sentences about yourself.",
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        isSettings?Navigator.of(context).pop():null;
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==== Reusable Section Card ====
  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  // ==== Reusable Text Field ====
  Widget _buildTextField({
    required String label,
    required String initialValue,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 6),
          TextFormField(
            enabled: enabled,
            initialValue: initialValue,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF2C2C2C),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  // ==== Reusable Text Area ====
  Widget _buildTextArea({required String label, required String hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 6),
          TextFormField(
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
              filled: true,
              fillColor: const Color(0xFF2C2C2C),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}
