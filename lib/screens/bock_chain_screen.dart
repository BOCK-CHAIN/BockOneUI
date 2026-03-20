import 'package:flutter/material.dart';
import 'package:trial/screens/hynorvixx.dart';
import 'package:trial/screens/krysonix/krysonix_auth_screen.dart';
import 'package:trial/screens/maps/maps_main.dart';
import 'package:trial/screens/bock_foods_entry.dart';
import 'package:trial/widgets/automotive_grid_item.dart';
import 'package:trial/screens/ruviel/ruviel_entry.dart';
import 'package:trial/screens/bock_drive/main.dart';
import 'package:trial/screens/bock_docs/main.dart';
import 'package:trial/screens/orventus/orventus_entry.dart';
import 'package:trial/screens/bock_vote_host_screen.dart';
import 'package:trial/screens/bock_defi_host_screen.dart';

class BockChainScreen extends StatelessWidget {
  const BockChainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    void openBockVote() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const BockVoteHostScreen()),
      );
    }

    int getCrossAxisCount() {
      if (screenWidth > 1200) return 4;
      if (screenWidth > 800) return 3;
      return 2;
    }

    double getChildAspectRatio() {
      if (screenWidth > 1200) return 1.35;
      return 1.15;
    }

    final items = <({String title, VoidCallback? onTap})>[
      (
        title: 'Krysonix',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const KrysonixAuthScreen()),
        ),
      ),
      (title: 'Xorvane', onTap: () {}),
      (
        title: 'Hynorvixx',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SampleGridScreen()),
        ),
      ),
      (
        title: 'Drive',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const BockDriveApp()),
        ),
      ),
      (
        title: 'Docs',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const BockDocsApp()),
        ),
      ),
      (
        title: 'Ruviel',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const RuvielEntry()),
        ),
      ),
      (
        title: 'Foods',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const BockFoodsEntry()),
        ),
      ),
      (
        title: 'Orventus',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const OrventusEntry()),
        ),
      ),
      (
        title: 'Bock Vote',
        onTap: () => openBockVote(),
      ),
      (title: 'Chain', onTap: () {}),
      (
        title: 'Browser',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const MyApp()),
        ),
      ),
      (
        title: 'De-Fi',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const BockDeFiHostScreen()),
        ),
      ),
    ];

    final content = GridView.count(
      padding: const EdgeInsets.all(20),
      crossAxisCount: getCrossAxisCount(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: getChildAspectRatio(),
      children: [
        for (final item in items)
          AutomotiveGridItem(
            title: item.title,
            height: 200,
            onTap: item.onTap,
          ),
      ],
    );

    return Scaffold(
      backgroundColor: const Color(0xFFEBDFF4), // Your background
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0), // Purple variant
        title: const Text("Bock Chain", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: content
    );
  }
}
