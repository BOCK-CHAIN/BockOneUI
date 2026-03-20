import 'package:flutter/material.dart';
import '../services/bock_foods_service.dart';
import 'category_page.dart';
import 'settings_page.dart';

class BockFoodsHomePage extends StatefulWidget {
  const BockFoodsHomePage({super.key});

  @override
  State<BockFoodsHomePage> createState() => _BockFoodsHomePageState();
}

class _BockFoodsHomePageState extends State<BockFoodsHomePage> {
  late Future<List<String>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = BockFoodsService.categories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBDFF4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        title: const Text('Bock Foods', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BockFoodsSettingsPage()),
              );
            },
          )
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final categories = snapshot.data ?? const ['Foods', 'Groceries', 'Dining'];

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final category = categories[i];
              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BockFoodsCategoryPage(category: category),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF9C27B0).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.restaurant, color: Color(0xFF6A1B9A)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            category,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

