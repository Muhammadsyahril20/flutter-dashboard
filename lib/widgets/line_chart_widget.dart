// lib/widgets/profit_line_chart_widget.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Package for number formatting
import '../models/profit_data.dart';

class ProfitLineChartWidget extends StatelessWidget {
  final List<ProfitData> profitData;

  const ProfitLineChartWidget({super.key, required this.profitData});

  @override
  Widget build(BuildContext context) {
    // Sort data by month to ensure the line chart connects points correctly
    // This is a safeguard; ideally, the API should return sorted data.
    final sortedData = List<ProfitData>.from(profitData)..sort((a, b) {
      final monthA = DateFormat.MMMM().parse(a.monthName).month;
      final monthB = DateFormat.MMMM().parse(b.monthName).month;
      return monthA.compareTo(monthB);
    });

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 55, // Give more space for the profit labels
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1, // Show every month label
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < sortedData.length) {
                  // Show the first 3 letters of the month name
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8.0,
                    child: Text(
                      sortedData[index].monthName.substring(0, 3),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (sortedData.length - 1).toDouble(), // X-axis from 0 to data count - 1
        minY: 0, // Y-axis starts from 0
        lineBarsData: [
          LineChartBarData(
            spots: sortedData.asMap().entries.map((e) {
              // x is the index, y is the total profit
              return FlSpot(e.key.toDouble(), e.value.totalProfit);
            }).toList(),
            isCurved: true,
            gradient: const LinearGradient(
              colors: [Colors.cyan, Colors.blue],
            ),
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.cyan.withOpacity(0.3),
                  Colors.blue.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final profit = spot.y;
                final month = sortedData[spot.x.toInt()].monthName;
                // Format the number to be more readable (e.g., $763.6K)
                final formattedProfit = NumberFormat.compactCurrency(
                  decimalDigits: 2,
                  symbol: '\$',
                ).format(profit);

                return LineTooltipItem(
                  '$month\n$formattedProfit',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
