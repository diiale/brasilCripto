import 'package:brasil_cripto/data/repositories/crypto_repository.dart';
import 'package:brasil_cripto/domain/entities/coin.dart';
import 'package:brasil_cripto/utils/result.dart';
import 'package:brasil_cripto/viewmodels/search_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeRepo extends CryptoRepository {
  FakeRepo(): super.throwable();

  @override
  Future<Result<List<Coin>>> searchByNameOrSymbol(String query, {String vsCurrency = 'usd', cancelToken}) async {
    if (query == 'err') return Err(Exception('x') as dynamic);
    return const Ok([Coin(id:'btc', name:'Bitcoin', symbol:'btc', price:1, change24h:0, marketCap:0, volume24h:0, imageUrl:'')]);
  }
}

void main() {
  test('search populates results', () async {
    final vm = SearchViewModel(FakeRepo());
    await vm.search('btc');
    expect(vm.state.results.isNotEmpty, true);
    expect(vm.state.loading, false);
  });
}
