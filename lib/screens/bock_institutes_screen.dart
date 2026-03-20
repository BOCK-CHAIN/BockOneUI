import 'package:flutter/material.dart';
import 'package:trial/widgets/automotive_grid_item.dart';

class BockInstitutesScreen extends StatelessWidget {
  const BockInstitutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Widget content=SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutomotiveGridItem(title: 'Technical Education',height: 300,onTap: (){},),
          const SizedBox(height: 20,),
          AutomotiveGridItem(title: 'Spiritual Education',height: 300,onTap: (){},),
        ],
      ),
    );

    if (screenWidth > 1200) {
      content=Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(child: AutomotiveGridItem(title: 'Technical Education',height: MediaQuery.of(context).size.height,onTap: (){},)),
            const SizedBox(width: 20,),
            Expanded(child: AutomotiveGridItem(title: 'Spiritual Education',height: MediaQuery.of(context).size.height,onTap: (){},)),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEBDFF4), // Your background
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0), // Purple variant
        title: const Text("Bock Institutes", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: content
    );
  }
}
