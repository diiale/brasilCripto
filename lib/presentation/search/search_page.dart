import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/state_search.dart';
import '../../viewmodels/favorites_viewmodel.dart';
import '../detail/detail_page.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();

}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Criptomoedas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'ids separados por vírgula (ex.: bitcoin,ethereum)',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => ref.read(searchProvider.notifier).search(_controller.text),
                ),
              ),
              onSubmitted: (v) => ref.read(searchProvider.notifier).search(v),
            ),
            const SizedBox(height: 12),
            if (state.loading) const LinearProgressIndicator(),
            if (state.error != null) Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(state.error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: state.results.isEmpty
                  ? const Center(child: Text('Nenhuma criptomoeda encontrada'))
                  : ListView.separated(
                itemCount: state.results.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final c = state.results[i];
                  return ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(c.imageUrl)),
                    title: Text('${c.name} (${c.symbol})'),
                    subtitle: Text('Preço: ${c.price.toStringAsFixed(2)} | 24h: ${c.change24h.toStringAsFixed(2)}%'),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () => ref.read(favoritesProvider.notifier).add(c),
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailPage(coinId: c.id, title: c.name))),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ref.read(searchProvider.notifier).search(_controller.text),
        icon: const Icon(Icons.search),
        label: const Text('Buscar'),
      ),
    );
  }
}
