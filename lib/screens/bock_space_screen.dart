import 'package:flutter/material.dart';
import 'package:trial/screens/bscr_screen.dart';
import 'package:trial/widgets/automotive_grid_item.dart';

class BockSpaceScreen extends StatelessWidget {
  const BockSpaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Widget content = SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutomotiveGridItem(
            title: 'BSCR',
            height: 150,
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const BscrScreen()));
            },
          ),
          const SizedBox(height: 10),
          AutomotiveGridItem(
            title: 'BSCS',
            height: 150,
            onTap: () {},
          ),
          const SizedBox(
            height: 10,
          ),
          AutomotiveGridItem(
            title: 'BSCM',
            height: 150,
            onTap: () {},
          ),
          const SizedBox(
            height: 10,
          ),
          AutomotiveGridItem(
            title: 'BICRT',
            height: 150,
            onTap: () {},
          ),
        ],
      ),
    );

    if (screenWidth > 1200) {
      content = Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: AutomotiveGridItem(
                    title: 'BSCR',
                    height: 300,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const BscrScreen()));
                    },
                  )),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: AutomotiveGridItem(
                    title: 'BSCS',
                    height: 300,
                    onTap: () {},
                  )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      child: AutomotiveGridItem(
                    title: 'BSCM',
                    height: 300,
                    onTap: () {},
                  )),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: AutomotiveGridItem(
                    title: 'BICRT',
                    height: 300,
                    onTap: () {},
                  )),
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
          title:
              const Text("Bock Space", style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: content);
  }
}
