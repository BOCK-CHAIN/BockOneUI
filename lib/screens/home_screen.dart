import 'package:flutter/material.dart';
import 'package:trial/screens/automotive_blog_page.dart';
import 'package:trial/screens/profile_screen.dart';
import 'package:trial/widgets/home_screen_grid_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key,required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFEBDFF4),
      body: SafeArea(
        child: Column(
          children: [
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
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ProfileScreen(username: userName,)),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Grid section with fixed height
            SizedBox(
              height: screenHeight * 0.83, // covers remaining space approx.
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.15, // Adjusted to fit screen
                children: [
                  HomeScreenGridItem(
                    title: 'Bock Automotive',
                    image: 'assets/images/automotive.png',
                    labelColor: Colors.red,
                    onSelectApp: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AutomotiveArticleScreen()));
                    },
                  ),
                  HomeScreenGridItem(
                    title: 'Bock Foods',
                    image: 'assets/images/foods.png',
                    labelColor: Colors.green,
                    onSelectApp: (){},
                  ),
                  HomeScreenGridItem(
                    title: 'Bock Space',
                    image: 'assets/images/space.png',
                    labelColor: Colors.indigo,
                    onSelectApp: (){},
                  ),
                  HomeScreenGridItem(
                    title: 'Bock AI',
                    image: 'assets/images/AI.png',
                    labelColor: Colors.deepOrange,
                    onSelectApp: (){},
                  ),
                  HomeScreenGridItem(
                    title: 'Bock Health',
                    image: 'assets/images/health.png',
                    labelColor: Colors.amber,
                    onSelectApp: (){},
                  ),
                  HomeScreenGridItem(
                    title: 'Bock Chain',
                    image: 'assets/images/chain.png',
                    labelColor: Colors.purple,
                    onSelectApp: (){},
                  ),
                  HomeScreenGridItem(
                    title: 'Bock Institutes',
                    image: 'assets/images/institutes.png',
                    labelColor: Colors.teal,
                    onSelectApp: (){},
                  ),
                  HomeScreenGridItem(
                    title: 'Bock Force',
                    image: 'assets/images/force.png',
                    labelColor: Colors.deepOrangeAccent,
                    onSelectApp: (){},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
