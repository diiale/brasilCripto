import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/coingecko_api.dart';
import '../../data/repositories/crypto_repository.dart';
import '../factories/data_factory.dart';

final dioProvider = Provider<Dio>((_) => DataFactory.createDio());

final apiProvider = Provider<CoinGeckoApi>(
      (ref) => DataFactory.createApi(ref.read(dioProvider)),
);

final repositoryProvider = Provider<CryptoRepository>(
      (ref) => CryptoRepository(ref.read(apiProvider)),
);
