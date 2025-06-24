// lib/models/top_product_data.dart

import 'dart:convert';

// Helper function to parse a list of top products from a JSON string
List<TopProductData> topProductDataFromJson(String str) => List<TopProductData>.from(json.decode(str).map((x) => TopProductData.fromJson(x)));

class TopProductData {
    final String product;
    final double totalUnits;

    TopProductData({
        required this.product,
        required this.totalUnits,
    });

    // Factory constructor to create an instance from a map (JSON object)
    factory TopProductData.fromJson(Map<String, dynamic> json) => TopProductData(
        // The API response for product has extra spaces, so we trim them
        product: json["product"].toString().trim(), 
        // The API returns a number, so we ensure it's a double
        totalUnits: (json["total_units"] as num).toDouble(),
    );
}
