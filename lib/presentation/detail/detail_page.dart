import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/detail_state.dart';

class DetailPage extends ConsumerStatefulWidget {
  final String coinId;
  final String title;
  const DetailPage({super.key, required this.coinId, required this.title});

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
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
          ? Center(child: Text(state.error!))
          : state.data == null
          ? const Center(child: Text('Sem dados'))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descrição', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(child: Text(state.data!.description.isEmpty ? 'Sem descrição disponível' : state.data!.description)),
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
                      spots: state.data!.prices.map((p) => FlSpot(p[0].toDouble(), (p[1]).toDouble())).toList(),
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
