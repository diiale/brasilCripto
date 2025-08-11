import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/state_detail.dart';
import '../widgets/price_chart.dart';
import '../widgets/skeletons.dart';

class DetailPage extends ConsumerStatefulWidget {
  final String coinId;
  final String title;
  final String? imageUrl;

  const DetailPage({
    super.key,
    required this.coinId,
    required this.title,
    this.imageUrl,
  });

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(detailProvider.notifier).load(widget.coinId));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(detailProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: state.loading
          ? ListView(
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
          RectSkeleton(height: 16, width: 120),
          SizedBox(height: 12),
          RectSkeleton(height: 12, width: double.infinity),
          SizedBox(height: 8),
          RectSkeleton(height: 12, width: double.infinity),
          SizedBox(height: 8),
          RectSkeleton(height: 12, width: 220),
          SizedBox(height: 24),
          RectSkeleton(height: 16, width: 160),
          SizedBox(height: 12),
          SizedBox(
            height: 240,
            child: RectSkeleton(
              height: double.infinity,
              width: double.infinity,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ],
      )
          : (state.error != null)
          ? Center(child: Text(state.error!))
          : state.data == null
          ? const Center(child: Text('Sem dados'))
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) ...[
            Center(
              child: Hero(
                tag: 'coin:${widget.coinId}',
                child: CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage(widget.imageUrl!),
                  onBackgroundImageError: (_, __) {},
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Descrição',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(
                    state.data!.description.isEmpty
                        ? 'Sem descrição disponível'
                        : state.data!.description,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          Text('Variação (7 dias)',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          SizedBox(
            height: 240,
            child: PriceChart(prices: state.data!.prices),
          ),
        ],
      ),
    );
  }
}
