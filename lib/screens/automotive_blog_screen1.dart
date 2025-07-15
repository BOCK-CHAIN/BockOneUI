import 'package:flutter/material.dart';

class AutomotiveArticleScreen extends StatelessWidget {
  const AutomotiveArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBDFF4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        title: const Text(
          "Bock Automotive",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🚗 The Future of Electric Vehicles",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A),
              ),
            ),
            const SizedBox(height: 16),

            // Article Image with shadow
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0,0,0,0.25),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  "https://cdn.pixabay.com/photo/2019/08/03/20/56/carsharing-4382651_1280.jpg",
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Card-style section
            _buildSectionCard(
              title: "Why Electric Vehicles Matter",
              content:
              "Electric vehicles (EVs) are transforming the auto industry with eco-friendly performance and cutting-edge innovation. "
                  "Governments across the globe are offering subsidies, making EVs more accessible and affordable than ever before.",
              icon: Icons.electric_car,
            ),

            const SizedBox(height: 20),

            _buildSectionCard(
              title: "⚡ EVs Are the Future",
              content:
              "• Zero tailpipe emissions help combat climate change.\n"
                  "• Lower running costs and fewer moving parts to maintain.\n"
                  "• Rapid advances in battery range and charging tech.\n"
                  "• Widespread charging infrastructure on the rise.",
              icon: Icons.trending_up,
            ),

            const SizedBox(height: 20),

            _buildSectionCard(
              title: "🚀 The Road Ahead",
              content:
              "Major auto manufacturers are investing heavily in EV innovation. "
                  "Expect smarter models, autonomous driving features, faster charging, and longer ranges. "
                  "EVs are not a trend—they’re a movement toward a sustainable future.",
              icon: Icons.add_road_sharp,
            ),

            const SizedBox(height: 30),
            Divider(color: Colors.purple.shade100, thickness: 1.2),

            // Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text("Back to Home"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C27B0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 6,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0,0,0,0.12),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.deepPurple),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B1FA2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
