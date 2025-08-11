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

  // cache: query -> (timestamp, dados) por 60s
  final Map<String, (DateTime ts, List<Coin> data)> _cache = {};

  Future<void> search(String rawQuery) async {
    final q = _sanitizeQuery(rawQuery);
    if (q == null) {
      state = state.copyWith(results: [], error: 'Termo inválido.');
      return;
    }

    // cache 60s
    final cached = _cache[q];
    if (cached != null && DateTime.now().difference(cached.$1).inSeconds < 60) {
      state = state.copyWith(loading: false, results: cached.$2, error: null);
      return;
    }

    // rate limit simples (250ms)
    final elapsed = DateTime.now().difference(_lastCall).inMilliseconds;
    if (elapsed < 250) {
      await Future.delayed(Duration(milliseconds: 250 - elapsed));
    }
    _lastCall = DateTime.now();

    // cancela chamada anterior
    _inFlight?.cancel('novo termo');
    _inFlight = CancelToken();

    state = state.copyWith(loading: true, error: null);

    final res = await repo.searchByNameOrSymbol(q, cancelToken: _inFlight);
    res.when(
      ok: (data) {
        _cache[q] = (DateTime.now(), data);
        state = state.copyWith(loading: false, results: data, error: null);
      },
      err: (fail) {
        // mensagem amigável para UI; detalhe técnico só no console (se quiser)
        state = state.copyWith(loading: false, error: fail.message);
      },
    );
  }

  /// Sanitiza a entrada do usuário para proteger API/UI.
  /// - trim
  /// - limite de 64 chars
  /// - remove caracteres de controle
  /// - normaliza espaços
  String? _sanitizeQuery(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.length > 64) return null;
    final safe = trimmed
        .replaceAll(RegExp(r'[\u0000-\u001F\u007F]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ');
    return safe;
  }
}
