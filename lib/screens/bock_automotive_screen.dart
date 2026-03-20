import 'package:flutter/material.dart';
import 'package:trial/screens/automotive_ev1_blog.dart';
import 'package:trial/screens/automotive_spv_blog.dart';
import 'package:trial/widgets/automotive_grid_item.dart';

class BockAutomotiveScreen extends StatelessWidget {
  const BockAutomotiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Widget content=SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutomotiveGridItem(title: 'Automotive EV 1',height: 150,onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AutomotiveEV1Screen()));},),
          const SizedBox(height: 10,),
          AutomotiveGridItem(title: 'Automotive SPV',height: 150,onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AutomotiveSPVScreen()));},),
          const SizedBox(height: 10,),
          AutomotiveGridItem(title: '2/3 Wheeler',height: 150,onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AutomotiveEV1Screen()));},),
          const SizedBox(height: 10,),
          AutomotiveGridItem(title: 'Hyperloop',height: 150,onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AutomotiveSPVScreen()));},),
        ],
      ),
    );

    if (screenWidth > 1200) {
      content=Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: AutomotiveGridItem(title: 'Automotive EV 1',height: 300,onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AutomotiveEV1Screen()));},)),
                const SizedBox(width: 20,),
                Expanded(child: AutomotiveGridItem(title: 'Automotive SPV',height: 300,onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AutomotiveSPVScreen()));},)),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(child: AutomotiveGridItem(title: '2/3 Wheeler',height: 300,onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AutomotiveEV1Screen()));},)),
                const SizedBox(width: 20,),
                Expanded(child: AutomotiveGridItem(title: 'Hyperloop',height: 300,onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AutomotiveSPVScreen()));},)),
              ],
            ),
          ],
        ),
      );
    }
      return Scaffold(
      backgroundColor: const Color(0xFFEBDFF4), // Your background
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0), // Purple variant
        title: const Text("Bock Automotive", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: content
    );
  }
}
