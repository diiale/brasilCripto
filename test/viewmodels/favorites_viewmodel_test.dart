import 'dart:convert';

import 'package:brasil_cripto/domain/entities/coin.dart';
import 'package:brasil_cripto/viewmodels/favorites_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('toggle adiciona e remove, persistindo no SharedPreferences', () async {
    final vm = FavoritesViewModel();
    final coin = const Coin(
      id: 'bitcoin',
      name: 'Bitcoin',
      symbol: 'btc',
      price: 1,
      change24h: 0,
      marketCap: 0,
      volume24h: 0,
      imageUrl: '',
    );

    await vm.toggle(coin);
    expect(vm.state.any((c) => c.id == 'bitcoin'), isTrue);

    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('fav_coins') ?? [];
    expect(list, isNotEmpty);
    final decoded = jsonDecode(list.first) as Map<String, dynamic>;
    expect(decoded['id'], 'bitcoin');

    await vm.toggle(coin);
    expect(vm.state.any((c) => c.id == 'bitcoin'), isFalse);
  });
}
