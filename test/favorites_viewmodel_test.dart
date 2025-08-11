import 'package:brasil_cripto/domain/entities/coin.dart';
import 'package:brasil_cripto/viewmodels/favorites_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test('toggle favorite adds then removes', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final vm = FavoritesViewModel();

    final coin = const Coin(
      id: 'bitcoin', name: 'Bitcoin', symbol: 'btc',
      price: 1, change24h: 0, marketCap: 0, volume24h: 0, imageUrl: '',
    );

    await vm.toggle(coin);
    expect(vm.state.any((c) => c.id == 'bitcoin'), true);

    await vm.toggle(coin);
    expect(vm.state.any((c) => c.id == 'bitcoin'), false);
  });
}
