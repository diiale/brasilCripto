import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/coin.dart';

import 'package:shared_preferences/shared_preferences.dart';

class FavoritesViewModel extends StateNotifier<List<Coin>> {
  FavoritesViewModel() : super(const []);
  static const _key = 'fav_coins';

  /// Carrega favoritos do storage local.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    final coins = list.map((e) {
      final m = jsonDecode(e) as Map<String, dynamic>;
      return Coin(
        id: m['id'],
        name: m['name'],
        symbol: m['symbol'],
        price: (m['price'] ?? 0).toDouble(),
        change24h: (m['change24h'] ?? 0).toDouble(),
        marketCap: (m['marketCap'] ?? 0).toDouble(),
        volume24h: (m['volume24h'] ?? 0).toDouble(),
        imageUrl: m['imageUrl'] ?? '',
      );
    }).toList();
    state = coins;
  }

  /// Adiciona um favorito (idempotente).
  Future<void> add(Coin c) async {
    if (state.any((e) => e.id == c.id)) return;
    final updated = [...state, c];
    state = updated;
    await _persist(updated);
  }

  /// Remove um favorito.
  Future<void> remove(String id) async {
    final updated = state.where((e) => e.id != id).toList();
    state = updated;
    await _persist(updated);
  }

  Future<void> _persist(List<Coin> data) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = data
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