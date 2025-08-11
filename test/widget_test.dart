import 'package:brasil_cripto/core/di/providers.dart';
import 'package:brasil_cripto/data/repositories/crypto_repository.dart';
import 'package:brasil_cripto/domain/entities/coin.dart';
import 'package:brasil_cripto/domain/entities/coin_detail.dart';
import 'package:brasil_cripto/presentation/home/home_page.dart';
import 'package:brasil_cripto/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Repo fake para testes de widget (sem chamadas de rede)
class FakeRepo extends CryptoRepository {
  FakeRepo() : super.throwable();

  @override
  Future<Result<List<Coin>>> searchByNameOrSymbol(
      String query, {
        String vsCurrency = 'usd',
        cancelToken,
      }) async {
    // Retorna dados estáticos independente do termo
    return const Ok([
      Coin(
        id: 'bitcoin',
        name: 'Bitcoin',
        symbol: 'btc',
        price: 100000.0,
        change24h: 1.23,
        marketCap: 1000000000,
        volume24h: 123456789,
        imageUrl: 'https://img/bitcoin.png',
      ),
      Coin(
        id: 'ethereum',
        name: 'Ethereum',
        symbol: 'eth',
        price: 5000.0,
        change24h: -0.5,
        marketCap: 500000000,
        volume24h: 987654321,
        imageUrl: 'https://img/eth.png',
      ),
    ]);
  }

  @override
  Future<Result<CoinDetail>> getDetail(
      String id, {
        String vsCurrency = 'usd',
        cancelToken,
      }) async {
    return Ok(CoinDetail(
      id: id,
      description: 'Moeda $id para testes',
      prices: [
        [DateTime.now().millisecondsSinceEpoch - 3600 * 1000, 1.0],
        [DateTime.now().millisecondsSinceEpoch, 2.0],
      ],
    ));
  }
}

void main() {
  testWidgets('Home -> SearchPage renderiza e busca com FakeRepo',
          (WidgetTester tester) async {
        //Monta o app com o repositoryProvider
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              repositoryProvider.overrideWithValue(FakeRepo()),
            ],
            child: const MaterialApp(home: HomePage()),
          ),
        );

        //A SearchPage deve exibir o título
        expect(find.text('Buscar Criptomoedas'), findsOneWidget);

        //Digita no campo de busca para disparar o search
        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        await tester.enterText(textField, 'btc');

        //A SearchPage usa debounce (~550ms); aguarde o ciclo de eventos
        await tester.pump(const Duration(milliseconds: 600)); // debounce
        await tester.pumpAndSettle();

        //Deve aparecer pelo menos um resultado do FakeRepo
        expect(find.text('Bitcoin'), findsWidgets);

        //Navega para a aba Favoritos (ícone coração) e volta
        //(apenas para garantir que a NavigationBar está funcionando)
        final favIcon = find.byIcon(Icons.favorite);
        if (favIcon.evaluate().isNotEmpty) {
          await tester.tap(favIcon);
          await tester.pumpAndSettle();
          // volta para buscar (ícone lupa)
          final searchIcon = find.byIcon(Icons.search);
          if (searchIcon.evaluate().isNotEmpty) {
            await tester.tap(searchIcon);
            await tester.pumpAndSettle();
          }
        }
      });
}
