class CryptoModel {
  final String id;
  final String symbol;
  final String name;
  final double currentPrice;
  final double priceChange24h;
  final double? marketCap;

  CryptoModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.priceChange24h,
    this.marketCap,
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      id: json['id'],
      symbol: json['symbol'].toString().toUpperCase(),
      name: json['name'],
      currentPrice: json['current_price'].toDouble(),
      priceChange24h: json['price_change_percentage_24h']?.toDouble() ?? 0.0,
      marketCap: json['market_cap']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'current_price': currentPrice,
      'price_change_percentage_24h': priceChange24h,
      'market_cap': marketCap,
    };
  }
}