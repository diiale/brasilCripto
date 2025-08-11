import 'package:brasil_cripto/presentation/widgets/price_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PriceChart constrói sem exceções e aceita série mínima', (tester) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final prices = [
      [now - 60 * 60 * 1000, 1.0],
      [now, 2.0],
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PriceChart(prices: prices),
        ),
      ),
    );

    expect(find.byType(PriceChart), findsOneWidget);
  });
}
