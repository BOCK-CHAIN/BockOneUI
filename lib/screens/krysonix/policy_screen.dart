import 'package:flutter/material.dart';

class PolicyScreen extends StatelessWidget {
  final String title;
  final String lastUpdated;
  final List<String> intro;
  final List<Map<String, dynamic>> sections;

  const PolicyScreen({
    super.key,
    required this.title,
    required this.lastUpdated,
    required this.intro,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title,style: const TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF121212),
      ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Last Updated: $lastUpdated",
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
              const SizedBox(height: 12),

              /// Introduction paragraphs
              ...intro.map((paragraph) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  paragraph,
                  style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.white),
                ),
              )),

              /// Sections
              ...sections.map((section) => _buildSection(section)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(Map<String, dynamic> section) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section["title"],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlueAccent,
            ),
          ),
          const SizedBox(height: 8),
          ...section["subsections"].map<Widget>((sub) => _buildSubsection(sub)),
        ],
      ),
    );
  }

  Widget _buildSubsection(Map<String, dynamic> sub) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sub["subtitle"],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          ...sub["bullets"].map<Widget>((bullet) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("• ", style: TextStyle(color: Colors.white)),
                Expanded(
                  child: Text(
                    bullet,
                    style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
