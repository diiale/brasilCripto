import 'package:brasil_cripto/data/datasources/icoingecko_api.dart';
import 'package:brasil_cripto/data/repositories/crypto_repository.dart';
import 'package:brasil_cripto/presentation/home/home_page.dart';
import 'package:brasil_cripto/state/state_search.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fake da API usada pelo repositório (sem rede nos testes).
class FakeApi implements ICoinGeckoApi {
  @override
  Future<Response> searchAssets(String query, {CancelToken? cancelToken}) async {
    final data = {
      'coins': (query.toLowerCase().contains('bit'))
          ? [
        {'id': 'bitcoin'},
      ]
          : [],
    };
    return Response(
      requestOptions: RequestOptions(path: '/search'),
      data: data,
      statusCode: 200,
    );
  }

  @override
  Future<Response> fetchMarkets({
    required String vsCurrency,
    String? ids,
    CancelToken? cancelToken,
  }) async {
    final list = (ids == null || !ids.contains('bitcoin'))
        ? <dynamic>[]
        : <dynamic>[
      {
        'id': 'bitcoin',
        'name': 'Bitcoin',
        'symbol': 'btc',
        'current_price': 100000.0,
        'price_change_percentage_24h': 1.5,
        'market_cap': 1000000000.0,
        'total_volume': 50000000.0,
        'image': 'https://example.com/btc.png',
      },
    ];

    return Response(
      requestOptions: RequestOptions(path: '/markets'),
      data: list,
      statusCode: 200,
    );
  }

  @override
  Future<(Response details, Response chart)> fetchCoinDetail(
      String id, {
        String vsCurrency = 'usd',
        CancelToken? cancelToken,
      }) async {
    // Não usado neste teste
    throw UnimplementedError();
  }
}

void main() {
  testWidgets('Home -> SearchPage renderiza e busca com FakeRepo', (tester) async {
    // Override do provider do repositório para usar a FakeApi
    final overrides = [
      repositoryProvider.overrideWithValue(CryptoRepository(FakeApi())),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: const MaterialApp(home: HomePage()),
      ),
    );

    // Primeiro frame
    await tester.pumpAndSettle();

    // Encontra o TextField da SearchPage
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    // Digita 'bit' -> vai parear com nosso Fake e resultar em 'Bitcoin'
    await tester.enterText(textField, 'bit');

    // Encontra a LUPA QUE É SUFIXO DO TEXTFIELD (e não a do BottomNavigationBar)
    final suffixSearchIcon = find.descendant(
      of: textField,
      matching: find.byIcon(Icons.search),
    );
    expect(suffixSearchIcon, findsOneWidget);

    // Toca a lupa do TextField para disparar a busca explicitamente
    await tester.tap(suffixSearchIcon);

    // Respeitar debounce (550ms) + throttle (até 250ms) + renderização
    await tester.pump(const Duration(milliseconds: 600)); // debounce
    await tester.pump(const Duration(milliseconds: 300)); // throttle
    await tester.pumpAndSettle(const Duration(milliseconds: 300)); // render

    // Deve aparecer "Bitcoin (btc)" dentro do CoinListTile
    expect(
      find.textContaining('Bitcoin'),
      findsWidgets,
      reason: 'Nenhum item com texto contendo "Bitcoin" foi encontrado após a busca.',
    );
  });
}
