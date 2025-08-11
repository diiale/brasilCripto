import 'package:brasil_cripto/data/datasources/icoingecko_api.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

class ApiMock extends Mock implements ICoinGeckoApi {}

//Ajuda o mocktail a registrar tipos genéricos
class _CancelTokenFake extends Fake implements CancelToken {}

void registerFallbacksForDio() {
  registerFallbackValue(_CancelTokenFake());
}
