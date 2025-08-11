import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/coingecko_api.dart';
import '../data/repositories/crypto_repository.dart';
import '../domain/entities/coin_detail.dart';
import '../viewmodels/detail_viewmodel.dart';

class DetailState {
  final bool loading;
  final CoinDetail? data;
  final String? error;
  const DetailState({this.loading=false, this.data, this.error});
  DetailState copyWith({bool? loading, CoinDetail? data, String? error}) =>
      DetailState(loading: loading ?? this.loading, data: data ?? this.data, error: error);
}

final detailRepositoryProvider =
Provider<CryptoRepository>((ref) => CryptoRepository(CoinGeckoApi()));

final detailProvider =
StateNotifierProvider<DetailViewModel, DetailState>(
        (ref) => DetailViewModel(ref.read(detailRepositoryProvider)));