class FoodItem {
  final String id;
  final String name;
  final String category;
  final String description;
  final String imageUrl;
  final double price;

  const FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? 'Unknown').toString(),
      category: (json['category'] ?? 'Foods').toString(),
      description: (json['description'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ?? json['image_url'] ?? '').toString(),
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse((json['price'] ?? '0').toString()) ?? 0,
    );
  }
}

