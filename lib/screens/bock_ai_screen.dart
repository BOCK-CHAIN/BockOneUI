import 'package:flutter/material.dart';
import 'package:trial/widgets/automotive_grid_item.dart';

class BockAIScreen extends StatelessWidget {
  const BockAIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Widget content= SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: AutomotiveGridItem(title: 'Orventus',height: 150,onTap: (){},)),
              const SizedBox(width: 10,),
              Expanded(child: AutomotiveGridItem(title: 'BAVT',height: 150,onTap: (){},)),
            ],
          ),
          const SizedBox(height: 10,),
          AutomotiveGridItem(title: 'Zeyon X90',height: 150,onTap: (){},),
          const SizedBox(height: 10,),
          AutomotiveGridItem(title: 'CPU',height: 150,onTap: (){},),
          const SizedBox(height: 10,),
          AutomotiveGridItem(title: 'Quantum Computers',height: 150,onTap: (){},),
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
                  Expanded(child: AutomotiveGridItem(title: 'Orventus',height: 300,onTap: (){},)),
                  const SizedBox(width: 20,),
                  Expanded(child: AutomotiveGridItem(title: 'BAVT',height: 300,onTap: (){},)),
                  const SizedBox(width: 20,),
                  Expanded(child: AutomotiveGridItem(title: 'Zeyon X90',height: 300,onTap: (){},)),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(child: AutomotiveGridItem(title: 'CPU',height: 300,onTap: (){},)),
                  const SizedBox(width: 20,),
                  Expanded(child: AutomotiveGridItem(title: 'Quantum Computers',height: 300,onTap: (){},)),
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
        title: const Text("Bock AI", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:content
    );
  }
}
