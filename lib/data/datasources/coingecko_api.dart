import 'package:dio/dio.dart';
import '../../core/errors/app_failure.dart';

class CoinGeckoApi {
  final Dio _dio;
  static const _base = 'https://api.coingecko.com/api/v3';

  CoinGeckoApi([Dio? dio])
      : _dio = dio ??
      Dio(BaseOptions(
        baseUrl: _base,
      ));

  Future<Response> fetchMarkets({
    required String vsCurrency,
    String? ids,
    CancelToken? cancelToken, // <---
  }) async {
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
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw AppFailure(e.message ?? 'Erro na API',
          statusCode: e.response?.statusCode);
    }
  }

  Future<Response> searchAssets(
      String query, {
        CancelToken? cancelToken,
      }) async {
    try {
      return await _dio.get(
        '/search',
        queryParameters: {'query': query},
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw AppFailure(e.message ?? 'Erro na API',
          statusCode: e.response?.statusCode);
    }
  }

  Future<(Response, Response)> fetchDetailsAndMarketChart({
    required String id,
    required String vsCurrency,
    CancelToken? cancelToken,
  }) async {
    try {
      final details = await _dio.get(
        '/coins/$id',
        queryParameters: {'localization': 'false'},
        cancelToken: cancelToken,
      );
      final chart = await _dio.get(
        '/coins/$id/market_chart',
        queryParameters: {'vs_currency': vsCurrency, 'days': 7},
        cancelToken: cancelToken,
      );
      return (details, chart);
    } on DioException catch (e) {
      throw AppFailure(e.message ?? 'Erro na API',
          statusCode: e.response?.statusCode);
    }
  }
}
