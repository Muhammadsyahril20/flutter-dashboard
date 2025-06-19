import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/sales_data.dart';

class BarChartWidget extends StatelessWidget {
  final List<SalesData> filteredData;

  const BarChartWidget({super.key, required this.filteredData});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                'Day ${filteredData[group.x].date}\n${filteredData[group.x].sales}',
                const TextStyle(color: Colors.white),
              );
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
        barGroups: filteredData.asMap().entries.map((e) => BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value.sales,
                  color: Colors.red,
                  width: 16,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            )).toList(),
        gridData: const FlGridData(show: true),
      ),
    );
  }
}