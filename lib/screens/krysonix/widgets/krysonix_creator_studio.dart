import 'package:flutter/material.dart';

class CreatorStudioScreen extends StatelessWidget {
  final bool isWeb;
  const CreatorStudioScreen({super.key,required this.isWeb});

  @override
  Widget build(BuildContext context) {
    return isWeb?SingleChildScrollView(
      padding:const EdgeInsets.all(16) ,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome message
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome Back likith",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Track and manage your channel and videos",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  fixedSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.upload, color: Colors.white),
                label: const Text("Upload", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),

          const SizedBox(height: 50),

          // Stats Cards
          const SizedBox(
            child: Row(
              children: [
                Expanded(child: _StatCard(title: "Total Views", value: "0", icon: Icons.visibility)),
                SizedBox(width: 12),
                Expanded(child: _StatCard(title: "Total followers", value: "0", icon: Icons.person)),
                SizedBox(width: 12),
                Expanded(child: _StatCard(title: "Total likes", value: "0", icon: Icons.favorite_border)),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Videos section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0F0F),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Videos",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Manage and track your uploaded content",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                SizedBox(height: 20,),

                // Table header
                Row(
                  children:[
                    Expanded(
                        flex: 1,
                        child: Text("Status",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 1,
                        child: Text("Video",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 1,
                        child: Text("Rating",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 1,
                        child: Text("Uploaded",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 1,
                        child: Text("Actions",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  ],
                ),

                Divider(color: Colors.white24, height: 20),
              ],
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    ):
    SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome message
          const Text(
            "Welcome Back likith",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Track and manage your channel and videos",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),

          const SizedBox(height: 16),

          // Upload button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {},
            icon: const Icon(Icons.upload, color: Colors.white),
            label: const Text("Upload", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 50),

          // Stats Cards
          const SizedBox(
            child: Column(
              children: [
                _StatCard(title: "Total Views", value: "0", icon: Icons.visibility),
                SizedBox(height: 12),
                _StatCard(title: "Total followers", value: "0", icon: Icons.person),
                SizedBox(height: 12),
                _StatCard(title: "Total likes", value: "0", icon: Icons.favorite_border),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Videos section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0F0F),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Videos",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Manage and track your uploaded content",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                SizedBox(height: 20,),

                // Table header
                Row(
                  children:[
                    Expanded(
                        flex: 1,
                        child: Text("Status",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 1,
                        child: Text("Video",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 1,
                        child: Text("Rating",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 1,
                        child: Text("Uploaded",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 1,
                        child: Text("Actions",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  ],
                ),

                Divider(color: Colors.white24, height: 20),
              ],
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

// ==== Reusable Stat Card ====
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 20),
              ),
              Icon(icon, color: Colors.white70, size: 28),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.purple,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
