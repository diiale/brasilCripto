class Coin {
  final String id;
  final String name;
  final String symbol;
  final double price;
  final double change24h;
  final double marketCap;
  final double volume24h;
  final String imageUrl;

  const Coin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.change24h,
    required this.marketCap,
    required this.volume24h,
    required this.imageUrl,
  });

  Coin copyWith({
    String? id,
    String? name,
    String? symbol,
    double? price,
    double? change24h,
    double? marketCap,
    double? volume24h,
    String? imageUrl,
  }) {
    return Coin(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      price: price ?? this.price,
      change24h: change24h ?? this.change24h,
      marketCap: marketCap ?? this.marketCap,
      volume24h: volume24h ?? this.volume24h,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() => 'Coin($id $symbol @$price)';

}