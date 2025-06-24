// lib/widgets/segment_pie_chart_widget.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/segement_data.dart';

class SegmentPieChartWidget extends StatelessWidget {
  final List<SegmentProfitData> segmentData;
  // Definisikan palet warna yang lebih kece
  final List<Color> chartColors = const [
    Color(0xff0293ee),
    Color(0xfff8b250),
    Color(0xff845bef),
    Color(0xff13d38e),
    Color(0xfff25f5c),
    Color(0xff222e50),
  ];

  const SegmentPieChartWidget({super.key, required this.segmentData});

  @override
  Widget build(BuildContext context) {
    if (segmentData.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No data to display for selected segments.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    // Hitung total profit untuk kalkulasi persentase
    final double totalProfit = segmentData.fold(0, (sum, item) => sum + item.totalProfit);

    return SizedBox(
      height: 200, // Beri tinggi yang fix agar tidak overflow
      child: Row(
        children: <Widget>[
          // Bagian untuk Pie Chart
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    // Bisa ditambahkan interaksi di sini nanti
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 30,
                sections: _generateChartSections(totalProfit),
              ),
            ),
          ),
          // Bagian untuk Legenda
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _generateLegends(),
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk membuat section pie chart
  List<PieChartSectionData> _generateChartSections(double totalProfit) {
    return List.generate(segmentData.length, (i) {
      final segment = segmentData[i];
      final percentage = (segment.totalProfit / totalProfit * 100);
      
      return PieChartSectionData(
        color: chartColors[i % chartColors.length],
        value: segment.totalProfit,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
        ),
      );
    });
  }

  // Helper untuk membuat widget legenda
  List<Widget> _generateLegends() {
    return List.generate(segmentData.length, (i) {
      final segment = segmentData[i];
      final color = chartColors[i % chartColors.length];
      // Format angka profit biar lebih gampang dibaca
      final formattedProfit = NumberFormat.compactCurrency(
        decimalDigits: 2,
        symbol: '\$',
      ).format(segment.totalProfit);

      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Indicator(
          color: color,
          text: '${segment.segment} ($formattedProfit)',
          isSquare: false,
          size: 14,
        ),
      );
    });
  }
}

// Widget custom untuk item legenda
class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    this.isSquare = true,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
