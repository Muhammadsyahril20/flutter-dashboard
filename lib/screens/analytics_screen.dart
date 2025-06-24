// lib/screens/analytics_screen.dart

import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:intl/intl.dart';
import '../controller/sales_controller.dart';
import '../models/sales_data.dart';
import '../models/profit_data.dart';
import '../models/top_product.dart';
import '../models/segement_data.dart'; // <-- IMPORT MODEL BARU
import '../widgets/bar_chart_widget.dart';
import '../widgets/line_chart_widget.dart';
import '../widgets/top_product.dart';
import '../widgets/SegmentPieChartWidget.dart'; // <-- IMPORT WIDGET PIE CHART BARU

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final SalesController _controller = SalesController();
  
  // State for Sales by Country (Bar Chart)
  List<SalesData> _allSalesData = [];
  List<SalesData> _filteredSalesData = [];
  List<Object?> _selectedCountries = [];
  bool _isLoadingSales = true;

  // State for Profit Trend (Line Chart)
  List<ProfitData> _allProfitData = [];
  List<ProfitData> _filteredProfitData = [];
  List<String> _availableYears = [];
  String? _selectedYear;
  bool _isLoadingProfit = true;

  // State for Top Products
  List<TopProductData> _allTopProducts = [];
  bool _isLoadingTopProducts = true;

  // --- STATE BARU UNTUK PROFIT BY SEGMENT ---
  List<SegmentProfitData> _segmentProfitData = [];
  bool _isLoadingSegmentProfit = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if(mounted) {
      setState(() {
        _isLoadingSales = true;
        _isLoadingProfit = true;
        _isLoadingTopProducts = true;
        _isLoadingSegmentProfit = true; // Set loading true untuk section baru
      });
    }

    // Fetch semua data secara bersamaan
    await Future.wait([
      // Fetch Sales Data
      _controller.fetchSalesData().then((data) {
        if (mounted) {
          setState(() {
            _allSalesData = data;
            _filteredSalesData = data;
            _selectedCountries = data.map((d) => d.country).toList();
            _isLoadingSales = false;
          });
        }
      }).catchError((e) { if (mounted) setState(() => _isLoadingSales = false); }),

      // Fetch Profit Summary
      _controller.fetchProfitSummary().then((data) {
        final years = data.map((d) => d.year.toString()).toSet().toList();
        years.sort((a, b) => b.compareTo(a));
        if (mounted) {
          setState(() {
            _allProfitData = data;
            _availableYears = years;
            if (_availableYears.isNotEmpty) _selectedYear = _availableYears.first;
            _isLoadingProfit = false;
            _filterProfitData();
          });
        }
      }).catchError((e) { if (mounted) setState(() => _isLoadingProfit = false); }),

      // Fetch Top Products Data
      _controller.fetchTopProducts().then((data) {
        if (mounted) {
          setState(() {
            data.sort((a, b) => b.totalUnits.compareTo(a.totalUnits));
            _allTopProducts = data;
            _isLoadingTopProducts = false;
          });
        }
      }).catchError((e) { if (mounted) setState(() => _isLoadingTopProducts = false); }),

      // --- FETCH DATA PROFIT BY SEGMENT ---
      _controller.fetchProfitBySegment().then((data) {
        if (mounted) {
          setState(() {
            // Urutkan berdasarkan profit terbesar
            data.sort((a, b) => b.totalProfit.compareTo(a.totalProfit));
            _segmentProfitData = data;
            _isLoadingSegmentProfit = false;
          });
        }
      }).catchError((e) { if (mounted) setState(() => _isLoadingSegmentProfit = false); }),
    ]);
  }
  
  void _filterSalesData() {
    setState(() {
      if (_selectedCountries.isEmpty) {
        _filteredSalesData = _allSalesData;
      } else {
        _filteredSalesData = _allSalesData
            .where((data) => _selectedCountries.contains(data.country))
            .toList();
      }
    });
  }

  void _filterProfitData() {
    setState(() {
      if (_selectedYear == null) {
        _filteredProfitData = _allProfitData;
      } else {
        _filteredProfitData = _allProfitData
            .where((data) => data.year.toString() == _selectedYear)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales & Profit Analytics'),
        centerTitle: true,
        backgroundColor: Colors.purple[700],
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSalesSection(),
              const SizedBox(height: 24),
              _buildProfitSection(),
              const SizedBox(height: 24),
              _buildSegmentProfitSection(), // <-- PANGGIL WIDGET SECTION BARU DI SINI
              const SizedBox(height: 24),
              _buildTopProductsSection(), 
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
    );
  }

  // --- WIDGET BARU UNTUK SECTION PROFIT BY SEGMENT ---
  Widget _buildSegmentProfitSection() {
    if (_isLoadingSegmentProfit) {
        return const Center(heightFactor: 5, child: CircularProgressIndicator());
    }
    if (_segmentProfitData.isEmpty) {
        return const Center(child: Text('No segment profit data available.'));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Profit by Segment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 8),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // Gunakan widget pie chart yang baru kita buat
            child: SegmentPieChartWidget(segmentData: _segmentProfitData),
          ),
        ),
      ],
    );
  }

  // Widget for Top Products Section (already exists)
  Widget _buildTopProductsSection() {
    if (_isLoadingTopProducts) {
        return const Center(heightFactor: 5, child: CircularProgressIndicator());
    }
    if (_allTopProducts.isEmpty) {
        return const Center(child: Text('No top product data available.'));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Top Selling Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 8),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TopProductsList(products: _allTopProducts),
          ),
        ),
      ],
    );
  }
  
  // Widget for the entire "Sales by Country" section (already exists)
  Widget _buildSalesSection() {
    if (_isLoadingSales) {
      return const Center(heightFactor: 5, child: CircularProgressIndicator());
    }
    if (_allSalesData.isEmpty) {
      return const Center(child: Text('No sales data available. Pull to refresh.'));
    }

    final totalSales = _filteredSalesData.isNotEmpty
        ? _filteredSalesData.map((d) => d.totalSales).reduce((a, b) => a + b)
        : 0.0;
    final topCountry = _filteredSalesData.isNotEmpty
        ? _filteredSalesData.reduce((a, b) => a.totalSales > b.totalSales ? a : b).country
        : 'N/A';
    
    final formattedTotalSales = NumberFormat.compactCurrency(
      decimalDigits: 2,
      symbol: '\$',
    ).format(totalSales);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildKpiCard('Total Sales', formattedTotalSales, Colors.orange, flex: 2),
            const SizedBox(width: 12),
            _buildKpiCard('Top Country', topCountry, Colors.green, flex: 3),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Sales by Country', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 8),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildCountryFilter(),
                const SizedBox(height: 20),
                SizedBox(
                  height: 300,
                  child: BarChartWidget(salesData: _filteredSalesData),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget for the entire "Profit Trend" section (already exists)
  Widget _buildProfitSection() {
    if (_isLoadingProfit) {
        return const Center(heightFactor: 5, child: CircularProgressIndicator());
    }
      if (_allProfitData.isEmpty) {
        return const Center(child: Text('No profit data available. Pull to refresh.'));
      }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Profit Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 8),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildYearFilter(),
                const SizedBox(height: 20),
                SizedBox(
                  height: 250,
                  child: _filteredProfitData.isEmpty
                    ? const Center(child: Text('No profit data for the selected year.'))
                    : ProfitLineChartWidget(profitData: _filteredProfitData),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget for KPI Card (already exists)
  Widget _buildKpiCard(String title, String value, Color color, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Filter widget for countries (already exists)
  Widget _buildCountryFilter() {
    final countryItems = _allSalesData
        .map((data) => MultiSelectItem<String>(data.country, data.country))
        .toList();

    return MultiSelectDialogField(
      items: countryItems,
      title: const Text("Select Countries"),
      selectedColor: Colors.purple,
      initialValue: _selectedCountries.cast<String>(),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: Colors.purple, width: 2),
      ),
      buttonIcon: const Icon(Icons.filter_list, color: Colors.purple),
      buttonText: Text("Filter by Country", style: TextStyle(color: Colors.purple[800], fontSize: 16)),
      onConfirm: (results) {
        _selectedCountries = results.cast<Object?>();
        _filterSalesData();
      },
    );
  }

  // Filter widget for year (already exists)
  Widget _buildYearFilter() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Select Year',
        labelStyle: const TextStyle(color: Colors.blueGrey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
      value: _selectedYear,
      items: _availableYears.map((year) => DropdownMenuItem<String>(
            value: year,
            child: Text(year),
          )).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedYear = value);
          _filterProfitData();
        }
      },
    );
  }
}
