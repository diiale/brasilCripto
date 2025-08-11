import '../../domain/entities/coin.dart';

class CoinMapper {
  static Coin? fromMarketJson(Map map) {
    final id = (map['id'] ?? '') as String;
    if (id.isEmpty) return null;

    final price = (map['current_price'] is num)
        ? (map['current_price'] as num).toDouble()
        : 0.0;

    final change = (map['price_change_percentage_24h'] is num)
        ? (map['price_change_percentage_24h'] as num).toDouble()
        : 0.0;

    final mcap = (map['market_cap'] is num)
        ? (map['market_cap'] as num).toDouble()
        : 0.0;

    final vol = (map['total_volume'] is num)
        ? (map['total_volume'] as num).toDouble()
        : 0.0;

    return Coin(
      id: id,
      name: (map['name'] ?? '') as String,
      symbol: (map['symbol'] ?? '') as String,
      price: price,
      change24h: change,
      marketCap: mcap,
      volume24h: vol,
      imageUrl: (map['image'] ?? '') as String,
    );
  }
}
