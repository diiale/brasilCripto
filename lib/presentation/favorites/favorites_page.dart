import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodels/favorites_viewmodel.dart';
import '../detail/detail_page.dart';
import '../widgets/coin_list_tile.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    // Garante que favoritos sejam carregados ao abrir a tela
    Future.microtask(() => ref.read(favoritesProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final favs = ref.watch(favoritesProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(favoritesProvider.notifier).load(),
        child: favs.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Center(child: Text('Sua lista de favoritos está vazia')),
          ],
        )
            : ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: favs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 4),
          itemBuilder: (context, i) {
            final c = favs[i];

            return CoinListTile(
              coin: c,
              showFavoriteAction: false,
              trailingAction: FilledButton.tonal(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Remover favorito?'),
                      content: Text('Deseja remover ${c.name}?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Remover'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await ref.read(favoritesProvider.notifier).remove(c.id);
                  }
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                ),
                child: const Text('Remover Favorito'),
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DetailPage(
                    id: c.id,
                    title: c.name,
                    coin: c,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
