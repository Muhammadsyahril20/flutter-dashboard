import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/segement_data.dart'; // Pastikan path import ini benar

class SegmentPieChartWidget extends StatelessWidget {
  final List<SegmentProfitData> segmentData;
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
    final double totalProfit =
        segmentData.fold(0, (sum, item) => sum + item.totalProfit);

    // GANTI LAYOUT DARI ROW MENJADI COLUMN
    return Column(
      mainAxisSize: MainAxisSize.min, // Biar ukuran Column pas dengan isinya
      children: <Widget>[
        // 1. BAGIAN PIE CHART
        SizedBox(
          height: 180, // Beri tinggi yang fix untuk chart
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  // Interaksi bisa ditambahkan di sini
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: _generateChartSections(totalProfit),
            ),
          ),
        ),
        const SizedBox(height: 20), // Jarak antara chart dan legenda

        // 2. BAGIAN LEGENDA (MENGGUNAKAN WRAP)
        // Wrap akan otomatis memindahkan item ke baris baru jika tidak muat
        Wrap(
          spacing: 16.0, // Jarak horizontal antar item legenda
          runSpacing: 8.0, // Jarak vertikal antar baris legenda
          alignment: WrapAlignment.center, // Pusatkan legenda
          children: _generateLegends(),
        ),
      ],
    );
  }

  List<PieChartSectionData> _generateChartSections(double totalProfit) {
    return List.generate(segmentData.length, (i) {
      final segment = segmentData[i];
      final percentage = (segment.totalProfit / totalProfit * 100);

      return PieChartSectionData(
        color: chartColors[i % chartColors.length],
        value: segment.totalProfit,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 55, // Sedikit sesuaikan radius
        titleStyle: const TextStyle(
          fontSize: 14, // Perbesar font sedikit biar jelas
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
        ),
      );
    });
  }

  // Helper untuk membuat widget legenda (sekarang return list dari Indicator)
  List<Widget> _generateLegends() {
    return List.generate(segmentData.length, (i) {
      final segment = segmentData[i];
      final color = chartColors[i % chartColors.length];
      final formattedProfit = NumberFormat.compactCurrency(
        decimalDigits: 2,
        symbol: '\$',
      ).format(segment.totalProfit);

      return Indicator(
        color: color,
        text: '${segment.segment} ($formattedProfit)',
        isSquare: false,
        size: 14,
      );
    });
  }
}

// Widget custom untuk item legenda (Indicator)
class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    this.isSquare = true,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    // Row ini sekarang menjadi item individu di dalam Wrap
    return Row(
      mainAxisSize: MainAxisSize.min, // Penting agar tidak makan tempat
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
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xff505050),
          ),
        ),
      ],
    );
  }
}