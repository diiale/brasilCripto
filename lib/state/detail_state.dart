import 'package:brasil_cripto/state/state_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final detailProvider = StateNotifierProvider.autoDispose<DetailViewModel, DetailState>((ref) {
  final repo = ref.read(repositoryProvider);
  return DetailViewModel(repo);
});