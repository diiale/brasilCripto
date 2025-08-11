import 'package:dio/dio.dart';
import '../../core/errors/app_failure.dart';
import '../../domain/entities/coin.dart';
import '../../domain/entities/coin_detail.dart';
import '../../utils/result.dart';
import '../datasources/icoingecko_api.dart';
import '../mappers/coin_mapper.dart';

class CryptoRepository {
  final ICoinGeckoApi api;
  CryptoRepository(this.api);

  Future<Result<List<Coin>>> searchByNameOrSymbol(
      String query, {
        String vsCurrency = 'usd',
        CancelToken? cancelToken,
      }) async {
    try {
      final search = await api.searchAssets(query, cancelToken: cancelToken);

      final coinsRaw =
      search.data is Map ? (search.data['coins'] as List?) : null;
      if (coinsRaw == null) return const Ok(<Coin>[]);

      final ids = coinsRaw
          .whereType<Map>()
          .map((m) => (m['id'] ?? '') as String)
          .where((id) => id.isNotEmpty)
          .toList();

      if (ids.isEmpty) return const Ok(<Coin>[]);

      final markets = await api.fetchMarkets(
        vsCurrency: vsCurrency,
        ids: ids.take(10).join(','), // limita payload
        cancelToken: cancelToken,
      );

      final list = (markets.data is List) ? (markets.data as List) : const [];
      final mapped = list
          .whereType<Map>()
          .map(CoinMapper.fromMarketJson)
          .whereType<Coin>()
          .toList();

      return Ok(mapped);
    } on AppFailure catch (e) {
      return Err(e);
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      if (code == 429) {
        return Err(const AppFailure(
          'Muitas buscas em sequência. Aguarde alguns segundos e tente novamente.',
          statusCode: 429,
        ));
      }
      return Err(AppFailure(
        'Falha ao buscar moedas. Código: $code',
        statusCode: code,
      ));
    } catch (e) {
      return Err(AppFailure('Erro inesperado: $e'));
    }
  }

  Future<Result<CoinDetail>> getDetail(
      String id, {
        String vsCurrency = 'usd',
        CancelToken? cancelToken,
      }) async {
    try {
      final (details, chart) = await api.fetchCoinDetail(
        id,
        vsCurrency: vsCurrency,
        cancelToken: cancelToken,
      );

      String desc = '';
      if (details.data is Map &&
          (details.data['description'] is Map) &&
          (details.data['description']['en'] is String)) {
        desc = details.data['description']['en'] as String;
      }

      final raw = (chart.data is Map) ? (chart.data['prices'] as List?) : null;
      if (raw == null) {
        return Ok(CoinDetail(id: id, description: desc, prices: const []));
      }

      final normalized = raw.whereType<List>().map<List<num>>((e) {
        final ts = (e.isNotEmpty && e[0] is num) ? (e[0] as num) : 0;
        final price = (e.length > 1 && e[1] is num) ? (e[1] as num) : 0;
        return <num>[ts, price];
      }).toList();

      return Ok(CoinDetail(
        id: id,
        description: desc,
        prices: normalized,
      ));
    } on AppFailure catch (e) {
      return Err(e);
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      return Err(AppFailure(
        'Falha ao carregar detalhes. Código: $code',
        statusCode: code,
      ));
    } catch (e) {
      return Err(AppFailure('Erro inesperado: $e'));
    }
  }

  CryptoRepository.throwable() : api = throw UnimplementedError();
}
