import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/state_search.dart';

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