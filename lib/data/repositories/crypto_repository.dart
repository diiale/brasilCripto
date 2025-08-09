import 'package:dio/dio.dart';

import '../../core/errors/app_failure.dart';
import '../../domain/entities/coin.dart';
import '../../utils/result.dart';
import '../datasources/coingecko_api.dart';

class CryptoRepository {
  final CoinGeckoApi api;
  CryptoRepository(this.api);

  /// Pesquisa moedas pelo(s) id(s) do CoinGecko (ex.: 'bitcoin,ethereum')
  Future<Result<List<Coin>>> searchCoins({required String ids, String vsCurrency = 'usd'}) async {
    try {
      final Response res = await api.fetchMarkets(vsCurrency: vsCurrency, ids: ids);
      final data = res.data as List<dynamic>;
      final coins = data.map((e) => Coin(
        id: e['id'],
        name: e['name'],
        symbol: (e['symbol'] ?? '').toString().toUpperCase(),
        price: (e['current_price'] ?? 0).toDouble(),
        change24h: (e['price_change_percentage_24h'] ?? 0).toDouble(),
        marketCap: (e['market_cap'] ?? 0).toDouble(),
        volume24h: (e['total_volume'] ?? 0).toDouble(),
        imageUrl: (e['image'] ?? '').toString(),
      )).toList();
      return Ok(coins);
    } catch (e) {
      if (e is AppFailure) return Err(e);
      return Err(AppFailure('Erro inesperado ao buscar moedas'));
    }
  }


}
