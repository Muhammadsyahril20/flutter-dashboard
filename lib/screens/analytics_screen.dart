import 'package:flutter/material.dart';
import '../models/sales_data.dart'; // Pastikan path ini sesuai
import '../widgets/bar_chart_widget.dart'; // Bar chart
import '../widgets/line_chart_widget.dart'; // Line chart
import '../widgets/pie_chart_widget.dart'; // Pie chart

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String? selectedDate;
  String? selectedMonth;
  String? selectedYear;

  final List<String> dates = List.generate(31, (index) => '${index + 1}');
  final List<String> months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  final List<String> years = ['2023', '2024', '2025'];

  List<SalesData> getFilteredData() {
    return dummyData.where((data) {
      bool matches = true;
      if (selectedDate != null) matches &= data.date == selectedDate;
      if (selectedMonth != null) matches &= data.month == selectedMonth;
      if (selectedYear != null) matches &= data.year == selectedYear;
      return matches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = getFilteredData();

    // Agregasi data untuk KPI
    final totalSales = filteredData.isNotEmpty
        ? filteredData.map((d) => d.sales).reduce((a, b) => a + b).toStringAsFixed(2)
        : '0.00';
    final totalProfit = filteredData.isNotEmpty
        ? filteredData.map((d) => d.profit).reduce((a, b) => a + b).toStringAsFixed(2)
        : '0.00';
    final avgCategoryShare = filteredData.isNotEmpty
        ? (filteredData.map((d) => d.categoryShare).reduce((a, b) => a + b) / filteredData.length).toStringAsFixed(2)
        : '0.00';
    final topProduct = filteredData.isNotEmpty
        ? filteredData.reduce((a, b) => a.sales > b.sales ? a : b).product
        : 'N/A';
    final topCity = filteredData.isNotEmpty
        ? filteredData.reduce((a, b) => a.sales > b.sales ? a : b).city
        : 'N/A';

    final kpiData = {
      'Total Sales': '$totalSales M',
      'Total Profit': '$totalProfit K',
      'Avg Category Share': '$avgCategoryShare %',
      'Top Product': topProduct,
      'Top City': topCity,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Analytics'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.purple[700],
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Cards Section (2 atas, 3 bawah)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildKpiCard(kpiData.entries.elementAt(0), 0, [
                      Colors.orange,
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                      Colors.purple,
                    ]),
                    _buildKpiCard(kpiData.entries.elementAt(1), 1, [
                      Colors.orange,
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                      Colors.purple,
                    ]),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildKpiCard(kpiData.entries.elementAt(2), 2, [
                      Colors.orange,
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                      Colors.purple,
                    ]),
                    _buildKpiCard(kpiData.entries.elementAt(3), 3, [
                      Colors.orange,
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                      Colors.purple,
                    ]),
                    _buildKpiCard(kpiData.entries.elementAt(4), 4, [
                      Colors.orange,
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                      Colors.purple,
                    ]),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Filter Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        _buildDropdown('Date', dates, selectedDate, (value) {
                          setState(() => selectedDate = value);
                        }),
                        _buildDropdown('Month', months, selectedMonth, (value) {
                          setState(() => selectedMonth = value);
                        }),
                        _buildDropdown('Year', years, selectedYear, (value) {
                          setState(() => selectedYear = value);
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Bar Chart Section
            const Text(
              'Daily Sales',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 200,
                  child: BarChartWidget(filteredData: filteredData),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Line Chart Section
            const Text(
              'Profit Trend',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 200,
                  child: LineChartWidget(filteredData: filteredData),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Pie Chart Section
            const Text(
              'Category Share',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 200,
                  child: PieChartWidget(filteredData: filteredData),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade100,
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value, ValueChanged<String?> onChanged) {
    return SizedBox(
      width: 120,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        value: value,
        items: [
          const DropdownMenuItem<String>(
            value: null,
            child: Text('All'),
          ),
          ...items.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              )),
        ],
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildKpiCard(MapEntry<String, String> entry, int index, List<Color> colors) {
    return Card(
      color: colors[index % colors.length],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: (MediaQuery.of(context).size.width - 36) / 2, // Sesuaikan untuk 2 card
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                entry.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dummy data (udah sesuai model lo)
List<SalesData> dummyData = [
  SalesData(date: '1', month: 'Jan', year: '2025', product: 'Electronics', city: 'Jakarta', sales: 10, profit: 5, categoryShare: 25),
  SalesData(date: '2', month: 'Jan', year: '2025', product: 'Clothing', city: 'Bandung', sales: 15, profit: 8, categoryShare: 30),
  SalesData(date: '3', month: 'Feb', year: '2025', product: 'Food', city: 'Surabaya', sales: 13, profit: 6, categoryShare: 20),
  SalesData(date: '4', month: 'Feb', year: '2024', product: 'Electronics', city: 'Jakarta', sales: 17, profit: 10, categoryShare: 15),
  SalesData(date: '5', month: 'Mar', year: '2024', product: 'Clothing', city: 'Bandung', sales: 12, profit: 7, categoryShare: 10),
];