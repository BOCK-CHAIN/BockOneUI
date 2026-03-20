import 'package:flutter/material.dart';

class AutomotiveSPVScreen extends StatelessWidget {
  const AutomotiveSPVScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBDFF4), // Your background
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0), // Purple variant
        title: const Text("Bock Automotive", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "The Future of Electric Vehicles (EVs)",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A), // Deep purple
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "https://cdn.pixabay.com/photo/2019/08/03/20/56/carsharing-4382651_1280.jpg",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Electric vehicles (EVs) are revolutionizing the automotive industry with their eco-friendly performance and sleek innovation. "
                  "Governments worldwide are supporting EV adoption with incentives, making them more accessible and affordable for everyday consumers.",
              style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              "Why EVs Are the Future",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7B1FA2),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "• Reduced emissions help fight climate change.\n"
                  "• Lower maintenance compared to gasoline vehicles.\n"
                  "• Continuous improvements in battery tech.\n"
                  "• Growing global charging infrastructure.",
              style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.6),
            ),
            const SizedBox(height: 20),
            const Text(
              "The Road Ahead",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7B1FA2),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "As major automakers invest in EV development, we can expect more affordable models, faster charging, and increased driving range. "
                  "EVs are not just a trend—they're the future of mobility.",
              style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text("Back to Home"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C27B0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
