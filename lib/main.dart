import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/splash/splash_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: BrasilCripto()));
}

class BrasilCripto extends ConsumerWidget {
  const BrasilCripto({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'BrasilCripto',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const SplashPage(),
    );
  }
}
