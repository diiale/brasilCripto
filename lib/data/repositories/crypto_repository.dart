import 'package:dio/dio.dart';
import '../../core/errors/app_failure.dart';
import '../../domain/entities/coin.dart';
import '../../domain/entities/coin_detail.dart';
import '../../utils/result.dart';
import '../datasources/coingecko_api.dart';

class CryptoRepository {
  final CoinGeckoApi api;
  CryptoRepository(this.api);

  Future<Result<List<Coin>>> searchByNameOrSymbol(
    String query, {
    String vsCurrency = 'usd',
    CancelToken? cancelToken,
  }) async {
    try {
      final sres = await api.searchAssets(query, cancelToken: cancelToken);
      final coinsList = (sres.data?['coins'] as List? ?? [])
          .cast<Map>()
          .where((m) => (m['id'] as String?)?.isNotEmpty == true)
          .toList();

      if (coinsList.isEmpty) return const Ok(<Coin>[]);

      final ids = coinsList.take(10).map((m) => m['id'] as String).join(',');

      final markets = await api.fetchMarkets(
        vsCurrency: vsCurrency,
        ids: ids,
        cancelToken: cancelToken,
      );

      final data = markets.data as List<dynamic>;
      final coins = data
          .map(
            (e) => Coin(
              id: e['id'],
              name: e['name'],
              symbol: (e['symbol'] ?? '').toString().toUpperCase(),
              price: (e['current_price'] ?? 0).toDouble(),
              change24h: (e['price_change_percentage_24h'] ?? 0).toDouble(),
              marketCap: (e['market_cap'] ?? 0).toDouble(),
              volume24h: (e['total_volume'] ?? 0).toDouble(),
              imageUrl: (e['image'] ?? '').toString(),
            ),
          )
          .toList();

      return Ok(coins);
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      if (code == 429) {
        return Err(
          AppFailure(
            'Muitas buscas em sequência. Aguarde alguns segundos e tente novamente.',
          ),
        );
      }
      return Err(AppFailure('Falha ao buscar moedas. Código: $code'));
    } catch (_) {
      return Err(AppFailure('Erro inesperado ao buscar moedas.'));
    }
  }

  Future<Result<CoinDetail>> getCoinDetail(
      String id, {
        String vsCurrency = 'usd',
        CancelToken? cancelToken,
      }) async {
    try {
      final (details, chart) = await api.fetchDetailsAndMarketChart(
        id: id,
        vsCurrency: vsCurrency,
        cancelToken: cancelToken,
      );

      final desc = (details.data?['description']?['en'] ?? '').toString();
      final prices = (chart.data?['prices'] as List? ?? const [])
          .cast<List>()
          .map((row) => [row[0] as num, (row[1] as num)])
          .toList();

      return Ok(CoinDetail(id: id, description: desc, prices: prices));
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      if (code == 429) {
        return Err(AppFailure('Muitas requisições. Aguarde alguns segundos e tente novamente.', statusCode: 429));
      }
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        return Err(AppFailure('Tempo de resposta excedido. Verifique sua conexão e tente novamente.'));
      }
      return Err(AppFailure('Falha ao buscar detalhes. Código: $code'));
    } catch (_) {
      return Err(AppFailure('Erro inesperado ao buscar detalhes'));
    }
  }
}
