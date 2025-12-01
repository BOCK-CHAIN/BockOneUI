import 'package:flutter/material.dart';

import 'golligog/golligo_main.dart';

class SampleGridScreen extends StatelessWidget {
  final List<Map<String, String>> items = [
    {"title": "Golligog", "image": 'assets/images/BockChainLogo.png'},
    {"title": "Maps", "image": "assets/images/BockChainLogo.png"},
    {"title": "Crypto", "image": "assets/images/BockChainLogo.png"},
    {"title": "Tech", "image": "assets/images/BockChainLogo.png"},
    {"title": "AI", "image": "assets/images/BockChainLogo.png"},
    {"title": "Gaming", "image": "assets/images/BockChainLogo.png"},
    {"title": "Finance", "image": "assets/images/BockChainLogo.png"},
    {"title": "Stock", "image": "assets/images/BockChainLogo.png"},
    {"title": "Travel", "image": "assets/images/BockChainLogo.png"},
    {"title": "Music", "image": "assets/images/BockChainLogo.png"},
    {"title": "Books", "image": "assets/images/BockChainLogo.png"},
    {"title": "Sports", "image": "assets/images/BockChainLogo.png"},
    {"title": "Movies", "image": "assets/images/BockChainLogo.png"},
    {"title": "Space", "image": "assets/images/BockChainLogo.png"},
    {"title": "Tools", "image": "assets/images/BockChainLogo.png"},
    {"title": "Books", "image": "assets/images/BockChainLogo.png"},
    {"title": "Sports", "image": "assets/images/BockChainLogo.png"},
    {"title": "Movies", "image": "assets/images/BockChainLogo.png"},
    {"title": "Space", "image": "assets/images/BockChainLogo.png"},
    {"title": "Tools", "image": "assets/images/BockChainLogo.png"},
  ];

  SampleGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAD6F3), // light purple
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("Hynorvixx",style: TextStyle(color: Colors.white),),
        leading: const BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,         // 4 items per row
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.75,    // height/width ratio similar to your UI
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if(items[index]["title"]=="Golligog"){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const GolligogApp()));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(2, 3),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.asset(
                          items[index]["image"]!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        items[index]["title"]!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
