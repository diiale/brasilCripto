import 'package:dio/dio.dart';
import '../../utils/result.dart';
import '../../domain/entities/coin.dart';
import '../../domain/entities/coin_detail.dart';

abstract class ICryptoRepository {
  Future<Result<List<Coin>>> searchByNameOrSymbol(String query, {String vsCurrency, CancelToken? cancelToken});
  Future<Result<CoinDetail>> getDetail(String id, {String vsCurrency, CancelToken? cancelToken});
}
