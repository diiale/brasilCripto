import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/coin.dart';

class FavoritesViewModel extends StateNotifier<List<Coin>> {
  FavoritesViewModel() : super(const []);
  static const _key = 'fav_coins';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    final coins = list.map((e) {
      final m = jsonDecode(e) as Map<String, dynamic>;
      return Coin(
        id: m['id'] as String,
        name: m['name'] as String,
        symbol: m['symbol'] as String,
        price: (m['price'] as num).toDouble(),
        change24h: (m['change24h'] as num).toDouble(),
        marketCap: (m['marketCap'] as num).toDouble(),
        volume24h: (m['volume24h'] as num).toDouble(),
        imageUrl: m['imageUrl'] as String,
      );
    }).toList();
    state = coins;
  }

  Future<void> add(Coin c) async {
    if (state.any((e) => e.id == c.id)) return;
    state = [...state, c];
    await _persist();
  }

  Future<void> remove(String id) async {
    state = state.where((e) => e.id != id).toList();
    await _persist();
  }

  Future<void> toggle(Coin c) async {
    if (state.any((e) => e.id == c.id)) {
      await remove(c.id);
    } else {
      await add(c);
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = state
        .map((c) => jsonEncode({
      'id': c.id,
      'name': c.name,
      'symbol': c.symbol,
      'price': c.price,
      'change24h': c.change24h,
      'marketCap': c.marketCap,
      'volume24h': c.volume24h,
      'imageUrl': c.imageUrl,
    }))
        .toList();
    await prefs.setStringList(_key, encoded);
  }
}

final favoritesProvider =
StateNotifierProvider<FavoritesViewModel, List<Coin>>(
      (ref) => FavoritesViewModel(),
);
