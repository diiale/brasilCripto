import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/crypto_repository.dart';
import '../state/state_detail.dart';

class DetailViewModel extends StateNotifier<DetailState> {
  final CryptoRepository repo;
  DetailViewModel(this.repo): super(const DetailState());

  Future<void> load(String id) async {
    state = state.copyWith(loading: true, error: null);
    final res = await repo.getCoinDetail(id);
    state = res.when(
      ok: (d) => state.copyWith(loading: false, data: d),
      err: (f) => state.copyWith(loading: false, error: f.message),
    );
  }
}