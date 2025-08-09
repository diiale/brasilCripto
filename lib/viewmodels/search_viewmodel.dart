import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/crypto_repository.dart';
import '../state/state_search.dart';

class SearchViewModel extends StateNotifier<SearchState> {
  final CryptoRepository repo;
  SearchViewModel(this.repo) : super(const SearchState());

  /// Realiza a busca; aceita nomes/ids separados por vírgula.
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(results: [], error: 'Digite o nome/id da moeda');
      return;
    }
    state = state.copyWith(loading: true, error: null);
    final res = await repo.searchCoins(ids: query.toLowerCase());
    state = res.when(
      ok: (list) => state.copyWith(loading: false, results: list),
      err: (f) => state.copyWith(loading: false, error: f.message),
    );
  }
}