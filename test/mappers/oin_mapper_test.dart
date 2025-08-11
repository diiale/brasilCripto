import 'package:brasil_cripto/data/mappers/coin_mapper.dart';
import 'package:brasil_cripto/domain/entities/coin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromMarketJson mapeia campos e ignora faltantes', () {
    final map = {
      'id': 'bitcoin',
      'name': 'Bitcoin',
      'symbol': 'btc',
      'current_price': 123.45,
      'price_change_percentage_24h': 1.2,
      'market_cap': 10,
      'total_volume': 20,
      'image': 'img',
    };

    final coin = CoinMapper.fromMarketJson(map);
    expect(coin, isA<Coin>());
    expect(coin!.id, 'bitcoin');
    expect(coin.price, 123.45);
  });

  test('fromMarketJson retorna null quando id vazio', () {
    final map = {'id': ''};
    final coin = CoinMapper.fromMarketJson(map);
    expect(coin, isNull);
  });
}
