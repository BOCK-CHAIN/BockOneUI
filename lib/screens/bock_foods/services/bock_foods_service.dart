import 'dart:convert';

import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/food_item.dart';
import 'auth_service.dart';

class BockFoodsService {
  static const _defaultImage =
      'https://static.toiimg.com/thumb/114088891/114088891.jpg?height=746&width=420&resizemode=76&imgsize=123356';

  /// Fetch categories from database, fallback to default if API unavailable
  static Future<List<String>> categories() async {
    final baseUrl = ApiConfig.baseUrl;
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return const ['Foods', 'Groceries', 'Dining', 'Drones', 'Agriculture'];
    }

    try {
      final uri = Uri.parse(baseUrl).replace(
        path: '${Uri.parse(baseUrl).path.replaceAll(RegExp(r"/+$"), "")}/api/categories',
      );

      final headers = await BockFoodsAuthService.getAuthHeaders();
      final res = await http.get(uri, headers: headers);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final decoded = jsonDecode(res.body);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList();
        }
      }
    } catch (e) {
      // Fallback to default categories on error
    }

    return const ['Foods', 'Groceries', 'Dining', 'Drones', 'Agriculture'];
  }

  static Future<List<FoodItem>> listItems({
    required String category,
    String? query,
  }) async {
    final baseUrl = ApiConfig.baseUrl;
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return _mockItems(category: category, query: query);
    }

    try {
      final headers = await BockFoodsAuthService.getAuthHeaders();
      List<FoodItem> items = [];

      // Map categories to appropriate API endpoints
      if (category == 'Foods' || category == 'Dining') {
        // Fetch menu items
        final uri = Uri.parse(baseUrl).replace(
          path: '${Uri.parse(baseUrl).path.replaceAll(RegExp(r"/+$"), "")}/api/menu-items',
          queryParameters: {
            if (category == 'Dining') 'cuisine': category,
            if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
          },
        );

        final res = await http.get(uri, headers: headers);
        if (res.statusCode >= 200 && res.statusCode < 300) {
          final decoded = jsonDecode(res.body);
          if (decoded is List) {
            items = decoded
                .whereType<Map<String, dynamic>>()
                .map((json) => _menuItemToFoodItem(json, category))
                .toList();
          }
        }
      } else if (category == 'Groceries') {
        // Fetch grocery items
        final uri = Uri.parse(baseUrl).replace(
          path: '${Uri.parse(baseUrl).path.replaceAll(RegExp(r"/+$"), "")}/api/grocerystores/items',
          queryParameters: {
            if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
          },
        );

        final res = await http.get(uri, headers: headers);
        if (res.statusCode >= 200 && res.statusCode < 300) {
          final decoded = jsonDecode(res.body);
          if (decoded is List) {
            items = decoded
                .whereType<Map<String, dynamic>>()
                .map((json) => _groceryItemToFoodItem(json, category))
                .toList();
          }
        }
      } else {
        // For other categories (Drones, Agriculture, or cuisine names), try menu items with cuisine filter
        final uri = Uri.parse(baseUrl).replace(
          path: '${Uri.parse(baseUrl).path.replaceAll(RegExp(r"/+$"), "")}/api/menu-items',
          queryParameters: {
            'cuisine': category,
            if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
          },
        );

        final res = await http.get(uri, headers: headers);
        if (res.statusCode >= 200 && res.statusCode < 300) {
          final decoded = jsonDecode(res.body);
          if (decoded is List) {
            items = decoded
                .whereType<Map<String, dynamic>>()
                .map((json) => _menuItemToFoodItem(json, category))
                .toList();
          }
        }
      }

      if (items.isNotEmpty) {
        return items;
      }
    } catch (e) {
      // Fallback to mock data on error
    }

    return _mockItems(category: category, query: query);
  }

  /// Convert MenuItem JSON to FoodItem
  static FoodItem _menuItemToFoodItem(Map<String, dynamic> json, String category) {
    return FoodItem(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? 'Unknown').toString(),
      category: category,
      description: (json['description'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ?? json['image_url'] ?? _defaultImage).toString(),
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse((json['price'] ?? '0').toString()) ?? 0,
    );
  }

  /// Convert GroceryItem JSON to FoodItem
  static FoodItem _groceryItemToFoodItem(Map<String, dynamic> json, String category) {
    final categoryName = json['category']?['name'] ?? category;
    return FoodItem(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? 'Unknown').toString(),
      category: categoryName,
      description: 'Stock: ${json['stock'] ?? 0}',
      imageUrl: (json['imageUrl'] ?? json['image_url'] ?? _defaultImage).toString(),
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse((json['price'] ?? '0').toString()) ?? 0,
    );
  }

  static List<FoodItem> _mockItems({
    required String category,
    String? query,
  }) {
    final items = <FoodItem>[
      FoodItem(
        id: '1',
        name: 'Bock Bowl',
        category: category,
        description: 'Protein + grains + fresh veggies. Quick and clean.',
        imageUrl: _defaultImage,
        price: 7.99,
      ),
      FoodItem(
        id: '2',
        name: 'Purple Wrap',
        category: category,
        description: 'A light wrap with a spicy sauce.',
        imageUrl: _defaultImage,
        price: 5.49,
      ),
      FoodItem(
        id: '3',
        name: 'Farm Pack',
        category: category,
        description: 'Weekly groceries pack with seasonal produce.',
        imageUrl: _defaultImage,
        price: 19.99,
      ),
    ];

    final q = query?.trim().toLowerCase();
    if (q == null || q.isEmpty) return items;
    return items.where((i) => i.name.toLowerCase().contains(q)).toList();
  }
}

