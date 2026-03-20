import 'package:flutter/material.dart';
import 'package:trial/widgets/automotive_grid_item.dart';

class ZeyonScreen extends StatelessWidget {
  const ZeyonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Widget content= SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
          AutomotiveGridItem(title: 'Zeyon G90',height: 150,onTap: (){},),
          const SizedBox(height: 10,),
          AutomotiveGridItem(title: 'Zeyon C90',height: 150,onTap: (){},),
          const SizedBox(height: 10,),
          AutomotiveGridItem(title: 'Zeyon QSC90',height: 150,onTap: (){},),
          const SizedBox(height: 10,),
          AutomotiveGridItem(title: 'Zeyon QPH90',height: 150,onTap: (){},),
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
                  Expanded(child: AutomotiveGridItem(title: 'Zeyon G90',height: 300,onTap: (){},)),
                  const SizedBox(width: 20,),
                  Expanded(child: AutomotiveGridItem(title: 'Zeyon C90',height: 300,onTap: (){},)),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(child: AutomotiveGridItem(title: 'Zeyon QSC90',height: 300,onTap: (){},)),
                  const SizedBox(width: 20,),
                  Expanded(child: AutomotiveGridItem(title: 'Zeyon QPH90',height: 300,onTap: (){},)),
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
          title: const Text("Zeyon", style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body:content
    );
  }
}
