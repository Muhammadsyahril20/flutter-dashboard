import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/sales_data.dart';

class LineChartWidget extends StatelessWidget {
  final List<SalesData> filteredData;

  const LineChartWidget({super.key, required this.filteredData});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${filteredData[spot.x.toInt()].profit}',
                  const TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < filteredData.length) {
                  return Text(filteredData[value.toInt()].date);
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: filteredData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.profit)).toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
          ),
        ],
        gridData: const FlGridData(show: true),
      ),
    );
  }
}