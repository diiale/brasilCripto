import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceChart extends StatelessWidget {
  final List<List<dynamic>> prices;
  const PriceChart({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text('Sem dados de gráfico')),
      );
    }

    final spots = <FlSpot>[];
    for (final row in prices) {
      if (row.length < 2) continue;
      final tsMs = _toNum(row[0]);
      final prc  = _toNum(row[1]);
      if (tsMs == null || prc == null) continue;
      if (!tsMs.isFinite || !prc.isFinite) continue;
      spots.add(FlSpot(tsMs.toDouble(), prc.toDouble())); // x = ms, y = preço
    }
    if (spots.length < 2) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text('Dados insuficientes para o gráfico')),
      );
    }
    spots.sort((a, b) => a.x.compareTo(b.x));

    // Limites
    final minX = spots.first.x;
    final maxX = spots.last.x;
    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);

    // Formatadores BR
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dfShort = DateFormat('dd/MM');
    final dfLong  = DateFormat('dd/MM HH:mm');

    // Se a faixa for curta (<= 2 dias), mostra data+hora; senão só data
    final showLong = (maxX - minX) <= Duration(days: 2).inMilliseconds;
    String fmtTs(double ms) =>
        (showLong ? dfLong : dfShort).format(DateTime.fromMillisecondsSinceEpoch(ms.toInt()));

    // Y: intervalo “simples”
    final spanY = (maxY - minY).abs();
    final yInterval = spanY == 0 ? 1.0 : (spanY / 4);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 24, 12, 12),
        child: SizedBox(
          height: 280,
          child: LineChart(
            LineChartData(
              clipData: const FlClipData.all(), // nada vaza
              minX: minX,
              maxX: maxX,
              minY: minY,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

                // Eixo Y com R$
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 58,
                    interval: yInterval,
                    getTitlesWidget: (value, meta) => SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 7,
                      child: Text(
                        currency.format(value),
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),

                // Eixo X: SOMENTE início e fim
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    getTitlesWidget: (value, meta) {
                      // Mostra label apenas se for muito perto do minX ou do maxX
                      final range = (maxX - minX).abs();
                      final nearStart = (value - minX).abs() <= range * 0.02;
                      final nearEnd   = (maxX - value).abs() <= range * 0.02;

                      if (!nearStart && !nearEnd) {
                        return const SizedBox.shrink();
                      }

                      // Alinhamento para ficar dentro do card
                      final align = nearEnd
                          ? Alignment.centerRight
                          : Alignment.centerLeft;

                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 6,
                        child: Align(
                          alignment: align,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: nearStart ? 8 : 0,
                              right: nearEnd ? 8 : 0,
                            ),
                            child: Text(
                              fmtTs(value),
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Tooltip: mostra data (curta/longa) + preço BR
              lineTouchData: LineTouchData(
                handleBuiltInTouches: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touched) => touched.map((item) {
                    final when = fmtTs(item.x);
                    final price = currency.format(item.y);
                    return LineTooltipItem(
                      '$when\n$price',
                      Theme.of(context).textTheme.bodySmall!,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helpers
  static num? _toNum(dynamic x) {
    if (x is num) return x;
    if (x is String) return num.tryParse(x);
    return null;
  }
}
