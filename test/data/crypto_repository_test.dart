import 'package:brasil_cripto/data/datasources/icoingecko_api.dart';
import 'package:brasil_cripto/data/repositories/crypto_repository.dart';
import 'package:brasil_cripto/domain/entities/coin.dart';
import 'package:brasil_cripto/utils/result.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fake da API que o repositório usa
class FakeApi implements ICoinGeckoApi {
  @override
  Future<Response> searchAssets(String query, {CancelToken? cancelToken}) async {
    // Simula a resposta do endpoint de busca do CoinGecko
    // Retorna uma lista com o id 'bitcoin' quando consultar 'bit'
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
    // Quando pedirem markets para 'bitcoin', devolve um item simples
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
    // Não é usado neste teste, mas mas implementado por conta da interface
    final details = Response(
      requestOptions: RequestOptions(path: '/coins/$id'),
      data: {
        'id': id,
        'name': 'Bitcoin',
        'symbol': 'btc',
        'description': {'en': '...'},
        'image': {'small': 'https://example.com/btc.png'},
      },
      statusCode: 200,
    );

    final chart = Response(
      requestOptions: RequestOptions(path: '/coins/$id/market_chart'),
      data: {
        'prices': [
          [1620000000000, 100000.0],
          [1620003600000, 100500.0],
        ],
      },
      statusCode: 200,
    );

    return (details, chart);
  }
}

void main() {
  late CryptoRepository repo;

  setUp(() {
    repo = CryptoRepository(FakeApi());
  });

  test('searchByNameOrSymbol retorna lista com Bitcoin', () async {
    final Result<List<Coin>> res = await repo.searchByNameOrSymbol('bit');

    expect(
      res,
      isA<Ok<List<Coin>>>(),
      reason: res is Err<List<Coin>> ? (res as Err<List<Coin>>).failure.message : null,
    );

    final ok = res as Ok<List<Coin>>;
    expect(ok.value, isNotEmpty);
    expect(ok.value.first.name, equals('Bitcoin'));
  });

  test('searchByNameOrSymbol vazio retorna lista vazia', () async {
    final Result<List<Coin>> res = await repo.searchByNameOrSymbol('zzz');
    final ok = res as Ok<List<Coin>>;
    expect(ok.value, isEmpty);
  });

  test('tratamento de erro 429 na busca', () async {
    // Exemplo de como simular 429:
    final api429 = _Api429();
    final repo429 = CryptoRepository(api429);

    final res = await repo429.searchByNameOrSymbol('qualquer');
    expect(res, isA<Err<List<Coin>>>());
    final err = res as Err<List<Coin>>;
    expect(err.failure.statusCode, 429);
  });
}

class _Api429 implements ICoinGeckoApi {
  @override
  Future<Response> searchAssets(String query, {CancelToken? cancelToken}) async {
    // Faz o fetchMarkets falhar, mas o searchAssets pode ser válido.
    return Response(
      requestOptions: RequestOptions(path: '/search'),
      data: {'coins': [{'id': 'bitcoin'}]},
      statusCode: 200,
    );
  }

  @override
  Future<Response> fetchMarkets({required String vsCurrency, String? ids, CancelToken? cancelToken}) async {
    throw DioException(
      requestOptions: RequestOptions(path: '/markets'),
      response: Response(requestOptions: RequestOptions(path: '/markets'), statusCode: 429),
      type: DioExceptionType.badResponse,
    );
  }

  @override
  Future<(Response, Response)> fetchCoinDetail(String id, {String vsCurrency = 'usd', CancelToken? cancelToken}) {
    throw UnimplementedError();
  }
}
