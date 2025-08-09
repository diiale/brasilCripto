import 'package:brasil_cripto/presentation/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: BrasilCriptoPlus()));
}

class BrasilCriptoPlus extends StatelessWidget {
  const BrasilCriptoPlus({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrasilCripto+',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}