import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/sales_data.dart';

class PieChartWidget extends StatelessWidget {
  final List<SalesData> filteredData;

  const PieChartWidget({super.key, required this.filteredData});

  @override
  Widget build(BuildContext context) {
    final uniqueProducts = filteredData.map((d) => d.product).toSet().toList();
    final pieData = uniqueProducts.map((product) {
      final value = filteredData.where((d) => d.product == product).map((d) => d.categoryShare).reduce((a, b) => a + b);
      return PieChartSectionData(
        value: value,
        color: Colors.primaries[uniqueProducts.indexOf(product) % Colors.primaries.length],
        title: product,
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: pieData,
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            // Bisa tambah interaksi di sini
          },
        ),
      ),
    );
  }
}