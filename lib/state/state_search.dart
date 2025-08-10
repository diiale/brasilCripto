import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/coingecko_api.dart';
import '../data/repositories/crypto_repository.dart';
import '../domain/entities/coin.dart';
import '../viewmodels/search_viewmodel.dart';

class SearchState {
  final bool loading;
  final List<Coin> results;
  final String? error;
  const SearchState({this.loading = false, this.results = const [], this.error});
  SearchState copyWith({bool? loading, List<Coin>? results, String? error}) =>
      SearchState(
        loading: loading ?? this.loading,
        results: results ?? this.results,
        error: error,
      );
}

final repositoryProvider = Provider<CryptoRepository>((ref) => CryptoRepository(CoinGeckoApi()));
final searchProvider = StateNotifierProvider<SearchViewModel, SearchState>((ref) => SearchViewModel(ref.read(repositoryProvider)));
