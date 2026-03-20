import 'package:flutter/material.dart';
import 'package:trial/screens/zeyon_screen.dart';
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
          const SizedBox(height: 10,),
          AutomotiveGridItem(title: 'Orventus',height: 200,onTap: (){},),
          const SizedBox(height: 10,),
          AutomotiveGridItem(title: 'BAVT',height: 200,onTap: (){},),
          const SizedBox(height: 10,),
          AutomotiveGridItem(title: 'Zeyon',height: 200,onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ZeyonScreen()));
          },),
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
                  Expanded(child: AutomotiveGridItem(title: 'Orventus',height: MediaQuery.of(context).size.height,onTap: (){},)),
                  const SizedBox(width: 20,),
                  Expanded(child: AutomotiveGridItem(title: 'BAVT',height: MediaQuery.of(context).size.height,onTap: (){},)),
                  const SizedBox(width: 20,),
                  Expanded(child: AutomotiveGridItem(title: 'Zeyon X90',height: MediaQuery.of(context).size.height,onTap: (){},)),
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
