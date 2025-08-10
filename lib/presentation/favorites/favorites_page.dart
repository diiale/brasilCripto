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
    Future.microtask(() => ref.read(favoritesProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final favs = ref.watch(favoritesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(favoritesProvider.notifier).load();
        },
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
          itemCount: favs.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final c = favs[i];
            return Dismissible(
              key: ValueKey(c.id),
              direction: DismissDirection.endToStart,
              confirmDismiss: (_) async {
                return await showDialog<bool>(
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
                ) ??
                    false;
              },
              onDismissed: (_) =>
                  ref.read(favoritesProvider.notifier).remove(c.id),
              background: Container(
                color: Theme.of(context).colorScheme.errorContainer,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete),
              ),
              child: CoinListTile(
                coin: c,
                showFavoriteAction: false,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        DetailPage(coinId: c.id, title: c.name, imageUrl: c.imageUrl),
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
