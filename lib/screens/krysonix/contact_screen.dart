import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  final Map<String, dynamic> contactData;

  const ContactUsScreen({super.key, required this.contactData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF121212),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Last Updated: ${contactData["lastUpdated"] ?? ""}",
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
              const SizedBox(height: 12),

              /// Introduction
              Text(
                contactData["introduction"] ?? "",
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              /// Sections
              ..._buildSections(contactData["sections"] ?? {}),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSections(Map<String, dynamic> sections) {
    return sections.entries.map((entry) {
      return _buildSection(entry.key, entry.value);
    }).toList();
  }

  Widget _buildSection(String title, dynamic content) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatTitle(title),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlueAccent,
            ),
          ),
          const SizedBox(height: 8),
          _buildContent(content),
        ],
      ),
    );
  }

  Widget _buildContent(dynamic content) {
    if (content is String) {
      return Text(
        content,
        style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
      );
    } else if (content is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content
            .map((e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("• ", style: TextStyle(color: Colors.white)),
              Expanded(
                child: Text(
                  e.toString(),
                  style: const TextStyle(
                      color: Colors.white, fontSize: 15, height: 1.4),
                ),
              ),
            ],
          ),
        ))
            .toList(),
      );
    } else if (content is Map) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content.entries.map((e) {
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatTitle(e.key),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                const SizedBox(height: 6),
                _buildContent(e.value),
              ],
            ),
          );
        }).toList(),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  String _formatTitle(String key) {
    return key.replaceAllMapped(
        RegExp(r'([a-z])([A-Z])'), (m) => "${m[1]} ${m[2]}").replaceAll("_", " ");
  }
}
