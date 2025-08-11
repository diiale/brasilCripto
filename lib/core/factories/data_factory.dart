import 'package:dio/dio.dart';
import '../../data/datasources/coingecko_api.dart';
import '../../data/repositories/crypto_repository.dart';

class DataFactory {
  static Dio createDio() => Dio(
    BaseOptions(
      baseUrl: 'https://api.coingecko.com/api/v3',
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
    ),
  );

  static CoinGeckoApi createApi([Dio? dio]) => CoinGeckoApi(dio ?? createDio());
  static CryptoRepository createRepo([Dio? dio]) => CryptoRepository(createApi(dio));
}
