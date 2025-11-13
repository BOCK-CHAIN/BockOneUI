import 'package:flutter/material.dart';
import 'package:trial/screens/golligog/golligo_main.dart';
import 'package:trial/screens/krysonix/krysonix_auth_screen.dart';
import 'package:trial/screens/maps/maps_main.dart';
import 'package:trial/widgets/automotive_grid_item.dart';

class BockChainScreen extends StatelessWidget {
  const BockChainScreen({super.key});

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
              Expanded(child: AutomotiveGridItem(title: 'Krysonix',height: 150,onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const KrysonixAuthScreen()));
              },)),
              const SizedBox(width: 10,),
              Expanded(child: AutomotiveGridItem(title: 'Xorvane',height: 150,onTap: (){},)),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: AutomotiveGridItem(title: 'Hynorvixx',height: 150,onTap: (){},)),
              const SizedBox(width: 10,),
              Expanded(child: AutomotiveGridItem(title: 'Bock Nexus',height: 150,onTap: (){},)),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: AutomotiveGridItem(title: 'Ruviel',height: 150,onTap: (){},)),
              const SizedBox(width: 10,),
              Expanded(child: AutomotiveGridItem(title: 'Chain',height: 150,onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GolligogApp()));
              },)),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: AutomotiveGridItem(title: 'Browser',height: 150,onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyApp()));
              },)),
              const SizedBox(width: 10,),
              Expanded(child: AutomotiveGridItem(title: 'De-Fi',height: 150,onTap: (){},)),
            ],
          ),
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
                  Expanded(child: AutomotiveGridItem(title: 'Krysonix',height: 300,onTap:(){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const KrysonixAuthScreen()));
                  })),
                  const SizedBox(width: 20,),
                  Expanded(child: AutomotiveGridItem(title: 'Xorvane',height: 300,onTap: (){},)),
                  const SizedBox(width: 20,),
                  Expanded(child: AutomotiveGridItem(title: 'Hynorvixx',height: 300,onTap: (){},)),
                  const SizedBox(width: 20,),
                  Expanded(child: AutomotiveGridItem(title: 'Bock Nexus',height: 300,onTap: (){},)),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(child: AutomotiveGridItem(title: 'Ruviel',height: 300,onTap: (){},)),
                  const SizedBox(width: 20,),
                  Expanded(child: AutomotiveGridItem(title: 'Chain',height: 300,onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GolligogApp()));
                  },)),
                  const SizedBox(width: 20,),
                  Expanded(child: AutomotiveGridItem(title: 'Browser',height: 300,onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyApp()));
                  },)),
                  const SizedBox(width: 20,),
                  Expanded(child: AutomotiveGridItem(title: 'De-Fi',height: 300,onTap: (){},)),
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
        title: const Text("Bock Chain", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: content
    );
  }
}
