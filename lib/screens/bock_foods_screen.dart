import 'package:flutter/material.dart';
import 'package:trial/widgets/automotive_grid_item.dart';

class BockFoodsScreen extends StatelessWidget {
  const BockFoodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Widget content=SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: AutomotiveGridItem(title: 'Foods',height: 200,onTap: (){},)),
              const SizedBox(width: 10,),
              Expanded(child: AutomotiveGridItem(title: 'Groceries',height: 200,onTap: (){},)),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: AutomotiveGridItem(title: 'Dining',height: 200,onTap: (){},)),
              const SizedBox(width: 10,),
              Expanded(child: AutomotiveGridItem(title: 'Drones',height: 200,onTap: (){},)),
            ],
          ),
          const SizedBox(height: 10,),
          AutomotiveGridItem(title: 'Agriculture',height: 200,onTap: (){},)
        ],
      ),
    );

    if (screenWidth > 1200) {
      content=Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(child: AutomotiveGridItem(title: 'Foods',height: MediaQuery.of(context).size.height,onTap: (){},)),
            const SizedBox(width: 20,),
            Expanded(child: AutomotiveGridItem(title: 'Groceries',height: MediaQuery.of(context).size.height,onTap: (){},)),
            const SizedBox(width: 20,),
            Expanded(child: AutomotiveGridItem(title: 'Dining',height: MediaQuery.of(context).size.height,onTap: (){},)),
            const SizedBox(width: 20,),
            Expanded(child: AutomotiveGridItem(title: 'Drones',height: MediaQuery.of(context).size.height,onTap: (){},)),
            const SizedBox(width: 20,),
            Expanded(child: AutomotiveGridItem(title: 'Agriculture',height: MediaQuery.of(context).size.height,onTap: (){},)),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEBDFF4), // Your background
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0), // Purple variant
        title: const Text("Bock Foods", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: content
    );
  }
}
