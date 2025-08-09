import 'package:dio/dio.dart';

import '../../core/errors/app_failure.dart';

class CoinGeckoApi {
  final Dio _dio;
  static const _base = 'https://api.coingecko.com/api/v3';

  CoinGeckoApi([Dio? dio]) : _dio = dio ?? Dio(BaseOptions(baseUrl: _base));

  /// Busca lista de moedas com preço, market cap e variação.
  /// [query] pode ser id(s) separados por vírgula (ex: 'bitcoin,ethereum') ou vazio para trending.
  Future<Response> fetchMarkets({required String vsCurrency, String? ids}) async {
    try {
      return await _dio.get(
        '/coins/markets',
        queryParameters: {
          'vs_currency': vsCurrency,
          if (ids != null && ids.isNotEmpty) 'ids': ids,
          'order': 'market_cap_desc',
          'per_page': 50,
          'page': 1,
          'sparkline': false,
          'price_change_percentage': '24h'
        },
      );
    } on DioException catch (e) {
      throw AppFailure(e.message ?? 'Erro na API', statusCode: e.response?.statusCode);
    }
  }

  /// Detalhes + histórico de preço curto
  Future<(Response, Response)> fetchDetailsAndMarketChart({required String id, required String vsCurrency}) async {
    try {
      final details = await _dio.get('/coins/$id', queryParameters: {'localization': 'false'});
      final chart = await _dio.get('/coins/$id/market_chart', queryParameters: {'vs_currency': vsCurrency, 'days': 7});
      return (details, chart);
    } on DioException catch (e) {
      throw AppFailure(e.message ?? 'Erro na API', statusCode: e.response?.statusCode);
    }
  }
}