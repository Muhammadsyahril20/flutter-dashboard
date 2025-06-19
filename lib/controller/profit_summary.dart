// lib/controllers/sales_controller.dart

import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/sales_data.dart';
import '../models/profit_data.dart'; // <-- IMPORT MODEL BARU

class SalesController {
  
  // Fungsi yang udah ada sebelumnya
  Future<List<SalesData>> fetchSalesData() async {
    final url = Uri.parse('${AppConfig.apiUrl}/analytics/country-comparison');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return salesDataFromJson(response.body);
      } else {
        throw Exception('Failed to load sales data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load sales data: $e');
    }
  }

  // --- FUNGSI BARU UNTUK PROFIT SUMMARY ---
  Future<List<ProfitData>> fetchProfitSummary() async {
    final url = Uri.parse('${AppConfig.apiUrl}/analytics/profit-summary');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Pake parser dari model ProfitData
        return profitDataFromJson(response.body);
      } else {
        throw Exception('Failed to load profit data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load profit data: $e');
    }
  }
}