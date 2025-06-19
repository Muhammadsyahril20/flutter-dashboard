// lib/screens/analytics_screen.dart

import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../controller/sales_controller.dart';
import '../models/sales_data.dart';
import '../models/profit_data.dart'; // <-- IMPORT MODEL PROFIT
import '../widgets/bar_chart_widget.dart';
import '../widgets/line_chart_widget.dart'; // <-- IMPORT WIDGET PROFIT LINE CHART

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final SalesController _controller = SalesController();
  
  // State for Sales by Country (Bar Chart)
  late Future<List<SalesData>> _salesDataFuture;
  List<SalesData> _allSalesData = [];
  List<SalesData> _filteredSalesData = [];
  List<Object?> _selectedCountries = [];

  // --- NEW STATE FOR PROFIT TREND (LINE CHART) ---
  late Future<List<ProfitData>> _profitDataFuture;
  List<ProfitData> _allProfitData = [];
  List<ProfitData> _filteredProfitData = [];
  List<String> _availableYears = [];
  String? _selectedYear;
  bool _isLoadingProfit = true; // Loading state for profit chart

  @override
  void initState() {
    super.initState();
    // Fetch data for both charts when the screen initializes
    _fetchData();
  }

  Future<void> _fetchData() async {
    // Fetch sales data
    _salesDataFuture = _controller.fetchSalesData().then((data) {
      if(mounted) {
        setState(() {
          _allSalesData = data;
          _filteredSalesData = data; // Initially, show all data
          _selectedCountries = data.map((d) => d.country).toList(); // Select all by default
        });
      }
      return data;
    });

    // --- FETCH PROFIT DATA ---
    _profitDataFuture = _controller.fetchProfitSummary().then((data) {
      // Get unique years from the data and sort them
      final years = data.map((d) => d.year.toString()).toSet().toList();
      years.sort((a, b) => b.compareTo(a)); // Sort from newest to oldest

      if(mounted) {
        setState(() {
          _allProfitData = data;
          _availableYears = years;
          // Set default filter to the most recent year
          if (_availableYears.isNotEmpty) {
            _selectedYear = _availableYears.first;
          }
          _isLoadingProfit = false; // Profit data loaded
          _filterProfitData(); // Immediately filter the data for the default year
        });
      }
      return data;
    });
  }
  
  // Filter function for sales data
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

  // --- NEW FILTER FUNCTION FOR PROFIT DATA ---
  void _filterProfitData() {
    setState(() {
      if (_selectedYear == null) {
        _filteredProfitData = _allProfitData; // If no year is selected, show all
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
              // --- Sales by Country Section ---
              _buildSalesSection(),
              const SizedBox(height: 24),
              
              // --- Profit Trend Section ---
              _buildProfitSection(),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
    );
  }

  // Widget for the entire "Sales by Country" section
  Widget _buildSalesSection() {
    return FutureBuilder<List<SalesData>>(
      future: _salesDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && _allSalesData.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading sales: ${snapshot.error}'));
        }
        if (_allSalesData.isEmpty) {
          return const Center(child: Text('No sales data available.'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
      },
    );
  }

  // Widget for the entire "Profit Trend" section
  Widget _buildProfitSection() {
    if (_isLoadingProfit) {
       return const Center(child: CircularProgressIndicator());
    }
     if (_allProfitData.isEmpty) {
        return const Center(child: Text('No profit data available.'));
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

  // Filter widget for countries
  Widget _buildCountryFilter() {
    final countryItems = _allSalesData
        .map((data) => MultiSelectItem<String>(data.country, data.country))
        .toList();

    return MultiSelectDialogField(
      items: countryItems,
      title: const Text("Select Countries"),
      selectedColor: Colors.purple,
      initialValue: _selectedCountries,
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: Colors.purple, width: 2),
      ),
      buttonIcon: const Icon(Icons.filter_list, color: Colors.purple),
      buttonText: Text("Filter by Country", style: TextStyle(color: Colors.purple[800], fontSize: 16)),
      onConfirm: (results) {
        setState(() {
          _selectedCountries = results.cast<Object?>();
        });
        _filterSalesData();
      },
    );
  }

  // --- NEW FILTER WIDGET FOR YEAR ---
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
