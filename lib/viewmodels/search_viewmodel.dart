import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/crypto_repository.dart';
import '../domain/entities/coin.dart';
import '../state/state_search.dart';

class SearchViewModel extends StateNotifier<SearchState> {
  final CryptoRepository repo;
  SearchViewModel(this.repo) : super(const SearchState());

  CancelToken? _inFlight;
  DateTime _lastCall = DateTime.fromMillisecondsSinceEpoch(0);

  // cache: query normalizada -> (timestamp, dados)
  final Map<String, (DateTime ts, List<Coin> data)> _cache = {};

  Future<void> search(String query) async {
    final q = query.trim().toLowerCase();

    // mínimo de caracteres para evitar flood
    if (q.length < 2) {
      state = state.copyWith(results: [], error: null, loading: false);
      _inFlight?.cancel();
      return;
    }

    // throttle: garante intervalo mínimo entre chamadas
    final now = DateTime.now();
    if (now.difference(_lastCall) < const Duration(milliseconds: 800)) {
      return;
    }
    _lastCall = now;

    // cache com TTL de 60s
    final cached = _cache[q];
    if (cached != null &&
        DateTime.now().difference(cached.$1) < const Duration(seconds: 60)) {
      state = state.copyWith(loading: false, results: cached.$2, error: null);
      return;
    }

    // cancela a requisição anterior (se existir)
    _inFlight?.cancel();
    _inFlight = CancelToken();

    state = state.copyWith(loading: true, error: null);

    final res = await repo.searchByNameOrSymbol(
      q,
      cancelToken: _inFlight,
    );

    state = res.when(
      ok: (list) {
        _cache[q] = (DateTime.now(), list);
        return state.copyWith(loading: false, results: list, error: null);
      },
      err: (f) => state.copyWith(loading: false, error: f.message),
    );
  }
}