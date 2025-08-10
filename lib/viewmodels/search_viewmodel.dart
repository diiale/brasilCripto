import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/crypto_repository.dart';
import '../state/state_search.dart';

class SearchViewModel extends StateNotifier<SearchState> {
  final CryptoRepository repo;
  SearchViewModel(this.repo) : super(const SearchState());

  // Agora busca por nome/símbolo usando /search e resolve para ids automaticamente.
  Future<void> search(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      state = state.copyWith(results: [], error: 'Digite nome ou símbolo da moeda');
      return;
    }
    state = state.copyWith(loading: true, error: null);
    final res = await repo.searchByNameOrSymbol(q);
    state = res.when(
      ok: (list) => state.copyWith(loading: false, results: list),
      err: (f) => state.copyWith(loading: false, error: f.message),
    );
  }
}