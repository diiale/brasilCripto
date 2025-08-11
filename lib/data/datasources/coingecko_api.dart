import 'package:dio/dio.dart';
import '../../core/errors/app_failure.dart';
import 'icoingecko_api.dart';

class CoinGeckoApi implements ICoinGeckoApi {
  final Dio _dio;
  static const _base = 'https://api.coingecko.com/api/v3';

  CoinGeckoApi([Dio? dio])
      : _dio = dio ??
      Dio(BaseOptions(
        baseUrl: _base,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        followRedirects: false,
        maxRedirects: 2,
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'BrasilCripto/1.0',
        },
        validateStatus: (code) => code != null && code >= 200 && code < 400,
      ));

  @override
  Future<Response> fetchMarkets({
    required String vsCurrency,
    String? ids,
    CancelToken? cancelToken,
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
          'price_change_percentage': '24h',
        },
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw AppFailure(
        e.message ?? 'Erro na API',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
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
      throw AppFailure(
        e.message ?? 'Erro na API',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<(Response details, Response chart)> fetchCoinDetail(
      String id, {
        String vsCurrency = 'usd',
        CancelToken? cancelToken,
      }) async {
    try {
      final details = await _dio.get(
        '/coins/$id',
        queryParameters: const {
          'localization': 'false',
          'tickers': 'false',
          'market_data': 'false',
          'community_data': 'false',
          'developer_data': 'false',
          'sparkline': 'false',
        },
        cancelToken: cancelToken,
      );

      final chart = await _dio.get(
        '/coins/$id/market_chart',
        queryParameters: {'vs_currency': vsCurrency, 'days': 7},
        cancelToken: cancelToken,
      );

      return (details, chart);
    } on DioException catch (e) {
      throw AppFailure(
        e.message ?? 'Erro na API',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
