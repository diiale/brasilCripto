import 'dart:convert';

import 'package:brasil_cripto/core/errors/app_failure.dart';
import 'package:brasil_cripto/data/repositories/crypto_repository.dart';
import 'package:brasil_cripto/utils/result.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/fixture.dart';
import '../helpers/response_builder.dart';
import '../mocks/api_mock.dart';

void main() {
  late ApiMock api;
  late CryptoRepository repo;

  setUpAll(() {
    registerFallbacksForDio();
  });

  setUp(() {
    api = ApiMock();
    repo = CryptoRepository(api);
  });

  test('searchByNameOrSymbol - sucesso mapeando mercados', () async {
    when(() => api.searchAssets('bit', cancelToken: any(named: 'cancelToken')))
        .thenAnswer((_) async => buildResponse(
      jsonDecode(fixture('search_success.json')),
      path: '/search',
    ));

    when(() => api.fetchMarkets(
      vsCurrency: any(named: 'vsCurrency'),
      ids: 'bitcoin,ethereum',
      cancelToken: any(named: 'cancelToken'),
    )).thenAnswer((_) async => buildResponse(
      jsonDecode(fixture('markets_success.json')),
      path: '/coins/markets',
    ));

    final res = await repo.searchByNameOrSymbol('bit');
    expect(res, isA<Ok>());
    res.when(
      ok: (list) {
        expect(list, isNotEmpty);
        expect(list.first.id, 'bitcoin');
        expect(list.first.price, greaterThan(0));
      },
      err: (_) => fail('não era para falhar'),
    );
  });

  test('searchByNameOrSymbol - 429 vira AppFailure amigável', () async {
    when(() => api.searchAssets('bit', cancelToken: any(named: 'cancelToken')))
        .thenThrow(DioException(
      requestOptions: RequestOptions(path: '/search'),
      response: Response(requestOptions: RequestOptions(), statusCode: 429),
    ));

    final res = await repo.searchByNameOrSymbol('bit');
    expect(res, isA<Err>());
    res.when(
      ok: (_) => fail('era para falhar'),
      err: (f) {
        expect(f, isA<AppFailure>());
        expect(f.statusCode, 429);
      },
    );
  });

  test('getDetail - normaliza prices para List<List<num>>', () async {
    when(() => api.fetchCoinDetail(
      'bitcoin',
      vsCurrency: any(named: 'vsCurrency'),
      cancelToken: any(named: 'cancelToken'),
    )).thenAnswer((_) async => (
    buildResponse(jsonDecode(fixture('detail_details.json')),
        path: '/coins/bitcoin'),
    buildResponse(jsonDecode(fixture('detail_chart.json')),
        path: '/coins/bitcoin/market_chart')
    ));

    final res = await repo.getDetail('bitcoin');
    res.when(
      ok: (d) {
        expect(d.description, isNotEmpty);
        expect(d.prices, isA<List<List<num>>>());
        expect(d.prices.length, greaterThanOrEqualTo(2));
        expect(d.prices.first[0], isA<num>());
        expect(d.prices.first[1], isA<num>());
      },
      err: (_) => fail('não era para errar'),
    );
  });
}
