import 'package:dio/dio.dart';

import '../../core/errors/app_failure.dart';
import '../../domain/entities/coin.dart';
import '../../domain/entities/coin_detail.dart';
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

  // NOVO: pesquisa por nome/símbolo e converte em ids para buscar no /coins/markets
  Future<Result<List<Coin>>> searchByNameOrSymbol(String query, {String vsCurrency = 'usd'}) async {
    try {
      final Response sres = await api.searchAssets(query);
      // Estrutura do /search: { coins: [ { id, name, api_symbol, symbol, market_cap_rank, thumb, ... } ], ... }
      final coinsList = (sres.data?['coins'] as List? ?? [])
          .cast<Map>()
          .where((m) => (m['id'] as String?)?.isNotEmpty == true)
          .toList();

      if (coinsList.isEmpty) {
        return const Ok(<Coin>[]);
      }

      // Pega os top N (ex.: 10) por relevância do /search
      final ids = coinsList.take(10).map((m) => m['id'] as String).join(',');

      // Busca os dados completos de mercado
      final markets = await api.fetchMarkets(vsCurrency: vsCurrency, ids: ids);
      final data = markets.data as List<dynamic>;
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
      return Err(AppFailure('Erro inesperado ao buscar moedas por nome/símbolo'));
    }
  }


  Future<Result<CoinDetail>> getCoinDetail(String id, {String vsCurrency = 'usd'}) async {
    try {
      final (details, chart) = await api.fetchDetailsAndMarketChart(id: id, vsCurrency: vsCurrency);
      final desc = (details.data?['description']?['en'] ?? '').toString();
      final prices = (chart.data?['prices'] as List).cast<List>().map((row) => [row[0] as num, (row[1] as num)]).toList();
      return Ok(CoinDetail(id: id, description: desc, prices: prices));
    } catch (e) {
      if (e is AppFailure) return Err(e);
      return Err(AppFailure('Erro inesperado ao buscar detalhes'));
    }
  }

}
