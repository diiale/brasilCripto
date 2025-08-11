import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/debouncer.dart';
import '../../state/state_search.dart';
import '../../viewmodels/favorites_viewmodel.dart';
import '../detail/detail_page.dart';
import '../widgets/coin_list_tile.dart';
import '../widgets/skeletons.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 550));

  @override
  void dispose() {
    _debouncer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      // sem AppBar — o título vai dentro do body
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Buscar Criptomoedas',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Digite o nome da criptomoeda',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () =>
                        ref.read(searchProvider.notifier).search(_controller.text),
                  ),
                ),
                onChanged: (v) {
                  _debouncer(() =>
                      ref.read(searchProvider.notifier).search(v));
                },
                onSubmitted: (v) =>
                    ref.read(searchProvider.notifier).search(v),
              ),

              const SizedBox(height: 12),

              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    state.error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              const SizedBox(height: 8),

              Expanded(
                child: state.loading
                    ? ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: 8,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, __) => const CoinTileSkeleton(),
                )
                    : (state.results.isEmpty
                    ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 120),
                    Center(child: Text('Nenhuma criptomoeda encontrada')),
                  ],
                )
                    : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.results.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final c = state.results[i];
                    final isFav = favorites.any((e) => e.id == c.id);

                    return CoinListTile(
                      coin: c,
                      isFavorite: isFav,
                      showFavoriteAction: true,
                      onFavorite: () async {
                        await ref.read(favoritesProvider.notifier).toggle(c);
                      },
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
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
