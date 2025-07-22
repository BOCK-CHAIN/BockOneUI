import 'package:flutter/material.dart';
import 'package:trial/widgets/automotive_grid_item.dart';

class BockForceScreen extends StatelessWidget {
  const BockForceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Widget content=SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutomotiveGridItem(title: 'Air Force',height: 200,onTap: (){},),
          const SizedBox(height: 10,),
          AutomotiveGridItem(title: 'Navy',height: 200,onTap: (){},),
          const SizedBox(height: 10,),
          AutomotiveGridItem(title: 'Army',height: 200,onTap: (){},),
        ],
      ),
    );

    if (screenWidth > 1200) {
      content=Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(child: AutomotiveGridItem(title: 'Air Force',height: MediaQuery.of(context).size.height,onTap: (){},)),
            const SizedBox(width: 20,),
            Expanded(child: AutomotiveGridItem(title: 'Navy',height: MediaQuery.of(context).size.height,onTap: (){},)),
            const SizedBox(width: 20,),
            Expanded(child: AutomotiveGridItem(title: 'Army',height: MediaQuery.of(context).size.height,onTap: (){},)),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEBDFF4), // Your background
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0), // Purple variant
        title: const Text("Bock Force", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: content
    );
  }
}
