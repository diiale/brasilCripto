import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/utils/formatters.dart';

class PriceChart extends StatelessWidget {
  final List<List<num>> prices;
  const PriceChart({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final spots = <FlSpot>[];
    for (var i = 0; i < prices.length; i++) {
      spots.add(FlSpot(i.toDouble(), (prices[i][1] as num).toDouble()));
    }
    if (spots.isEmpty) {
      return Card(
        elevation: 0,
        color: cs.surfaceContainerHighest.withOpacity(.35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Center(child: Text('Sem dados de gráfico')),
      );
    }

    final ys = spots.map((e) => e.y);
    final minY = ys.reduce((a, b) => a < b ? a : b);
    final maxY = ys.reduce((a, b) => a > b ? a : b);
    final pad = ((maxY - minY).abs()) * 0.08;

    DateTime _dt(int idx) =>
        DateTime.fromMillisecondsSinceEpoch((prices[idx][0] as num).toInt());

    final tickCountX = 4;
    final stepX = (spots.length / tickCountX).clamp(1, 999).floor();

    return Card(
      elevation: 0,
      color: cs.surfaceContainerHighest.withOpacity(.35),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 10, 10),
        child: LineChart(
          LineChartData(
            minY: minY - pad,
            maxY: maxY + pad,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 75,
                  interval: ((maxY - minY).abs() / 4).clamp(0.01, 1e12),
                  getTitlesWidget: (v, __) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      BrFormat.moedaCompact(v),
                      style: Theme.of(context).textTheme.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 26,
                  interval: stepX.toDouble(),
                  getTitlesWidget: (v, __) {
                    final idx = v.round();
                    if (idx <= 0 || idx >= spots.length) {
                      return const SizedBox.shrink();
                    }
                    if (idx % stepX != 0) {
                      return const SizedBox.shrink();
                    }
                    final dt = _dt(idx);
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${dt.day}/${dt.month}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    );
                  },
                ),
              ),
              rightTitles: const AxisTitles(),
              topTitles: const AxisTitles(),
            ),

            gridData: FlGridData(
              drawVerticalLine: false,
              horizontalInterval: ((maxY - minY).abs() / 4).clamp(0.01, 1e12),
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: cs.outlineVariant.withOpacity(.5), strokeWidth: .6),
            ),
            borderData: FlBorderData(show: false),

            lineTouchData: LineTouchData(
              handleBuiltInTouches: true,
              touchTooltipData: LineTouchTooltipData(
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                tooltipRoundedRadius: 10,
                tooltipPadding: const EdgeInsets.all(8),
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((t) {
                    final idx = t.x.round().clamp(0, spots.length - 1);
                    final dt = _dt(idx);
                    return LineTooltipItem(
                      '${BrFormat.dataHora(dt)}\n${BrFormat.moeda(t.y)}',
                      Theme.of(context).textTheme.labelLarge!,
                    );
                  }).toList();
                },
              ),
            ),

            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: 2.2,
                isStrokeCapRound: true,
                color: cs.primary,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [cs.primary.withOpacity(.30), cs.primary.withOpacity(0)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                dotData: const FlDotData(show: false),
                gradient: LinearGradient(
                  colors: [cs.primary, cs.secondary],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}