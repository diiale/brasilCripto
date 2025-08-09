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
}