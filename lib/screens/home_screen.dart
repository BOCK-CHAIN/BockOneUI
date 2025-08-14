import 'package:flutter/material.dart';
import 'package:trial/screens/bock_automotive_screen.dart';
import 'package:trial/screens/bock_ai_screen.dart';
import 'package:trial/screens/bock_chain_screen.dart';
import 'package:trial/screens/bock_foods_screen.dart';
import 'package:trial/screens/bock_force_screen.dart';
import 'package:trial/screens/bock_health_screen.dart';
import 'package:trial/screens/bock_institutes_screen.dart';
import 'package:trial/screens/bock_space_screen.dart';
import 'package:trial/screens/profile_screen.dart';
import 'package:trial/widgets/home_screen_grid_item.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.userName});
  String userName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Dynamically decide grid columns based on screen width
    int getCrossAxisCount() {
      if (screenWidth > 1200) return 4; // Large screen (web or desktop)
      if (screenWidth > 800) return 3; // Tablet
      return 2; // Mobile
    }

    double getChildAspectRatio() {
      if (screenWidth > 1200) return 1.2; // Compact aspect ratio for web
      return 1.1; // Normal for mobile
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEBDFF4),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu, color: Color(0xFF6A1B9A), size: 28),
                  const Text(
                    'Bock One',
                    style: TextStyle(
                      color: Color(0xFF6A1B9A),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline, color: Color(0xFF6A1B9A)),
                    onPressed: () async{
                      final updated = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ProfileScreen(username: widget.userName)),
                      );

                      if (updated is String && updated != widget.userName) {
                        setState(() {
                          widget.userName= updated; // update locally
                        });
                      }
                    },
                  ),
                ],
              ),
            ),

            // Responsive GridView
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.count(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    crossAxisCount: getCrossAxisCount(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: getChildAspectRatio(),
                    children: [
                      HomeScreenGridItem(
                        title: 'Bock Automotive',
                        image: 'assets/images/automotive.png',
                        labelColor: Colors.red,
                        onSelectApp: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BockAutomotiveScreen()));
                        },
                      ),
                      HomeScreenGridItem(
                        title: 'Bock Foods',
                        image: 'assets/images/foods.png',
                        labelColor: Colors.green,
                        onSelectApp: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BockFoodsScreen()));
                        },
                      ),
                      HomeScreenGridItem(
                        title: 'Bock Space',
                        image: 'assets/images/space.png',
                        labelColor: Colors.indigo,
                        onSelectApp: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BockSpaceScreen()));
                        },
                      ),
                      HomeScreenGridItem(
                        title: 'Bock AI',
                        image: 'assets/images/AI.png',
                        labelColor: Colors.deepOrange,
                        onSelectApp: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BockAIScreen()));
                        },
                      ),
                      HomeScreenGridItem(
                        title: 'Bock Health',
                        image: 'assets/images/health.png',
                        labelColor: Colors.amber,
                        onSelectApp: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BockHealthScreen()));
                        },
                      ),
                      HomeScreenGridItem(
                        title: 'Bock Chain',
                        image: 'assets/images/chain.png',
                        labelColor: Colors.purple,
                        onSelectApp: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BockChainScreen()));
                        },
                      ),
                      HomeScreenGridItem(
                        title: 'Bock Institutes',
                        image: 'assets/images/institutes.png',
                        labelColor: Colors.teal,
                        onSelectApp: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BockInstitutesScreen()));
                        },
                      ),
                      HomeScreenGridItem(
                        title: 'Bock Force',
                        image: 'assets/images/force.png',
                        labelColor: Colors.deepOrangeAccent,
                        onSelectApp: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BockForceScreen()));
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
