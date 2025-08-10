import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../favorites/favorites_page.dart';
import '../search/search_page.dart';

class HomePage extends ConsumerStatefulWidget  {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _index = 0;
  final _pages = const [SearchPage(), FavoritesPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/branding/logo.png',
          height: 280,
        ),
      ),
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.search), label: 'Buscar'),
          NavigationDestination(icon: Icon(Icons.favorite, color: Colors.red), label: 'Favoritos'),
        ],
        onDestinationSelected: (i) => setState(() => _index = i),
      ),
    );
  }
}
