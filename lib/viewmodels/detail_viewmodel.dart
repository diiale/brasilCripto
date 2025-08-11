import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/crypto_repository.dart';
import '../state/state_detail.dart';

class DetailViewModel extends StateNotifier<DetailState> {
  final CryptoRepository repo;
  DetailViewModel(this.repo) : super(const DetailState());

  Future<void> load(String id) async {
    state = state.copyWith(loading: true, error: null);
    final res = await repo.getDetail(id);
    res.when(
      ok: (data) => state = state.copyWith(loading: false, data: data),
      err: (fail) =>
      state = state.copyWith(loading: false, error: fail.message),
    );
  }
}
