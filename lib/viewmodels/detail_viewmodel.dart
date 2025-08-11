import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/crypto_repository.dart';
import '../state/state_detail.dart';

class DetailViewModel extends StateNotifier<DetailState> {
  final CryptoRepository repo;
  DetailViewModel(this.repo) : super(const DetailState());

  CancelToken? _inFlight;

  Future<void> load(String id) async {
    _inFlight?.cancel();
    _inFlight = CancelToken();

    state = state.copyWith(loading: true, error: null);

    try {
      final res = await repo.getCoinDetail(id, cancelToken: _inFlight);
      state = res.when(
        ok: (d) => state.copyWith(data: d, error: null),
        err: (f) => state.copyWith(error: f.message),
      );
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  @override
  void dispose() {
    _inFlight?.cancel();
    super.dispose();
  }
}