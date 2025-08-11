import 'package:dio/dio.dart';

abstract class ICoinGeckoApi {
  Future<Response> fetchMarkets({required String vsCurrency, String? ids, CancelToken? cancelToken});
  Future<Response> searchAssets(String query, {CancelToken? cancelToken});
  Future<(Response details, Response chart)> fetchCoinDetail(String id, {String vsCurrency, CancelToken? cancelToken});
}
