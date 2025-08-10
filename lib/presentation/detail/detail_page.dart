import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../state/state_detail.dart';
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
          ? Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + título
            Row(
              children: const [
                CircleSkeleton(size: 72),
                SizedBox(width: 16),
                Expanded(child: RectSkeleton(height: 20, width: double.infinity)),
              ],
            ),
            const SizedBox(height: 24),

            // Seção: Descrição (título + 3 linhas)
            const RectSkeleton(height: 16, width: 120),
            const SizedBox(height: 12),
            const RectSkeleton(height: 12, width: double.infinity),
            const SizedBox(height: 8),
            const RectSkeleton(height: 12, width: double.infinity),
            const SizedBox(height: 8),
            const RectSkeleton(height: 12, width: 220),

            const SizedBox(height: 24),

            // Seção: Gráfico (título + caixa grande)
            const RectSkeleton(height: 16, width: 160),
            const SizedBox(height: 12),
            Expanded(
              child: RectSkeleton(
                height: double.infinity,
                width: double.infinity,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
          ],
        ),
      )
          : (state.error != null
          ? Center(child: Text(state.error!))
          : state.data == null
          ? const Center(child: Text('Sem dados'))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
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
            if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
              const SizedBox(height: 16),

            Text('Descrição', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  state.data!.description.isEmpty
                      ? 'Sem descrição disponível'
                      : state.data!.description,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Variação (7 dias)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      spots: state.data!.prices
                          .map((p) => FlSpot(p[0].toDouble(), (p[1] as num).toDouble()))
                          .toList(),
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
