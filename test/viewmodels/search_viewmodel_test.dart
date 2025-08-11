import 'package:brasil_cripto/data/repositories/crypto_repository.dart';
import 'package:brasil_cripto/domain/entities/coin.dart';
import 'package:brasil_cripto/utils/result.dart';
import 'package:brasil_cripto/viewmodels/search_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class RepoMock extends Mock implements CryptoRepository {}

void main() {
  late RepoMock repo;
  late SearchViewModel vm;

  setUp(() {
    repo = RepoMock();
    vm = SearchViewModel(repo);
  });

  test('sanitização: vazio gera erro e resultados vazios', () async {
    await vm.search('   ');
    expect(vm.state.error, isNotNull);
    expect(vm.state.results, isEmpty);
  });

  test('cache 60s evita segunda chamada ao repo', () async {
    when(() => repo.searchByNameOrSymbol('btc', cancelToken: any(named: 'cancelToken')))
        .thenAnswer((_) async => const Ok([
      Coin(
        id: 'bitcoin',
        name: 'Bitcoin',
        symbol: 'btc',
        price: 1,
        change24h: 0,
        marketCap: 0,
        volume24h: 0,
        imageUrl: '',
      )
    ]));

    await vm.search('btc');
    final first = vm.state.results;
    await vm.search('btc');
    expect(vm.state.results, same(first));
    verify(() => repo.searchByNameOrSymbol('btc', cancelToken: any(named: 'cancelToken'))).called(1);
  });
}
