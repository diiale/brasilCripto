import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/coin.dart';
import '../../state/state_detail.dart';
import '../widgets/price_chart.dart';
import '../widgets/skeletons.dart';

class DetailPage extends ConsumerStatefulWidget {
  final String id;
  final String title;
  final Coin? coin;

  const DetailPage({
    super.key,
    required this.id,
    required this.title,
    this.coin,
  });

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  @override
  void initState() {
    super.initState();
    // Carrega os detalhes ao entrar na tela (uma vez)
    Future.microtask(() {
      ref.read(detailProvider.notifier).load(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(detailProvider);
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Builder(
        builder: (context) {
          if (state.loading) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                Row(
                  children: [
                    CircleSkeleton(size: 72),
                    SizedBox(width: 16),
                    Expanded(child: RectSkeleton(height: 20, width: double.infinity)),
                  ],
                ),
                SizedBox(height: 24),
                RectSkeleton(height: 160, width: double.infinity),
                SizedBox(height: 16),
                RectSkeleton(height: 16, width: double.infinity),
                SizedBox(height: 8),
                RectSkeleton(height: 16, width: double.infinity),
              ],
            );
          }

          if (state.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.error!,
                  style: text.titleMedium?.copyWith(color: cs.error),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state.data == null) {
            return const Center(child: Text('Sem dados para exibir.'));
          }

          final d = state.data!;
          // Algumas descrições do CoinGecko vêm com HTML; versão simples de “limpeza”.
          final description = _stripHtml(d.description).trim();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header com nome/símbolo/preço quando disponível
              if (widget.coin != null) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.coin!.imageUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.monetization_on, size: 40),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${widget.coin!.name} (${widget.coin!.symbol.toUpperCase()})',
                              style: text.titleLarge),
                          const SizedBox(height: 4),
                          Text('Preço: ${widget.coin!.price.toStringAsFixed(2)}',
                              style: text.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Gráfico de preços 7d
              Card(
                elevation: 0,
                color: cs.surfaceContainerHighest.withOpacity(.35),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: PriceChart(prices: d.prices),
                ),
              ),

              const SizedBox(height: 16),

              Text('Descrição', style: text.titleMedium),
              const SizedBox(height: 8),
              Text(
                description.isEmpty ? 'Sem descrição disponível.' : description,
                style: text.bodyMedium,
              ),
            ],
          );
        },
      ),
    );
  }
}

String _stripHtml(String input) {
  final noTags = input.replaceAll(RegExp(r'<[^>]*>'), ' ');
  return noTags.replaceAll(RegExp(r'\s+'), ' ');
}
