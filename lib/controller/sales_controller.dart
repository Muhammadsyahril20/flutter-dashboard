// lib/controller/sales_controller.dart

import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/sales_data.dart';
import '../models/profit_data.dart'; // <-- IMPORT MODEL PROFIT YANG BARU
import '../models/top_product.dart';
import '../models/segement_data.dart'; // <-- IMPORT MODEL BARU


class SalesController {
  
  // This function for the bar chart already exists
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

  // --- NEW FUNCTION TO FETCH PROFIT SUMMARY ---
  Future<List<ProfitData>> fetchProfitSummary() async {
    final url = Uri.parse('${AppConfig.apiUrl}/analytics/profit-summary');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Use the new parser from the ProfitData model
        return profitDataFromJson(response.body);
      } else {
        throw Exception('Failed to load profit data: ${response.statusCode}');
      }
    } catch (e) {
      // Catch other errors like no internet connection
      throw Exception('Failed to load profit data: $e');
    }
  }

   Future<List<TopProductData>> fetchTopProducts() async {
    final url = Uri.parse('${AppConfig.apiUrl}/analytics/top-products');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Use the parser from the TopProductData model
        return topProductDataFromJson(response.body);
      } else {
        throw Exception('Failed to load top products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load top products: $e');
    }
  }

  Future<List<SegmentProfitData>> fetchProfitBySegment() async {
    // Endpoint yang kamu kasih
    final url = Uri.parse('${AppConfig.apiUrl}/analytics/profit-by-segment');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Gunakan parser dari model yang baru kita buat
        return segmentProfitDataFromJson(response.body);
      } else {
        throw Exception('Failed to load segment profit data: ${response.statusCode}');
      }
    } catch (e) {
      // Menangkap error lain, misalnya koneksi internet putus
      throw Exception('Failed to load segment profit data: $e');
    }
  }
}
