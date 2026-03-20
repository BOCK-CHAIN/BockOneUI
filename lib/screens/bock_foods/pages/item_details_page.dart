import 'package:flutter/material.dart';
import '../models/food_item.dart';

class BockFoodsItemDetailsPage extends StatelessWidget {
  final FoodItem item;
  const BockFoodsItemDetailsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBDFF4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        title: Text(item.name, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              item.imageUrl,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 220,
                color: Colors.black12,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            item.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            item.category,
            style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(item.description, style: const TextStyle(height: 1.4)),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A1B9A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added (stub)')),
                    );
                  },
                  child: Text('Add • \$${item.price.toStringAsFixed(2)}'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

