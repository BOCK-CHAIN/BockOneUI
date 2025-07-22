import 'package:flutter/material.dart';
import 'package:trial/widgets/automotive_grid_item.dart';

class BockSpaceScreen extends StatelessWidget {
  const BockSpaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Widget content=SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutomotiveGridItem(title: 'Inertia Nano',height: 110,onTap: (){},),
          const SizedBox(height: 15,),
          AutomotiveGridItem(title: 'Inertia',height: 110,onTap: (){},),
          const SizedBox(height: 15,),
          AutomotiveGridItem(title: 'Inertia Mega',height: 110,onTap: (){},),
          const SizedBox(height: 15,),
          AutomotiveGridItem(title: 'Momentum',height: 110,onTap: (){},),
          const SizedBox(height: 15,),
          AutomotiveGridItem(title: 'Fully Reusable Rocket',height: 110,onTap: (){},),
        ],
      ),
    );

    if (screenWidth > 1200) {
      content=Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: AutomotiveGridItem(title: 'Inertia Nano',height: 300,onTap: (){},)),
                  const SizedBox(width: 20,),
                  Expanded(child: AutomotiveGridItem(title: 'Inertia',height: 300,onTap: (){},)),
                  const SizedBox(width: 20,),
                  Expanded(child: AutomotiveGridItem(title: 'Inertia Mega',height: 300,onTap: (){},)),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(child: AutomotiveGridItem(title: 'Momentum',height: 300,onTap: (){},)),
                  const SizedBox(width: 20,),
                  Expanded(child: AutomotiveGridItem(title: 'Fully Reusable Rocket',height: 300,onTap: (){},)),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEBDFF4), // Your background
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0), // Purple variant
        title: const Text("Bock Space", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: content
    );
  }
}
