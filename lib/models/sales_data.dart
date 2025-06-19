// lib/models/sales_data.dart

import 'dart:convert';

// Fungsi buat nge-parse list dari JSON
List<SalesData> salesDataFromJson(String str) => List<SalesData>.from(json.decode(str).map((x) => SalesData.fromJson(x)));

// Fungsi buat nge-serialize list ke JSON (kalau butuh)
String salesDataToJson(List<SalesData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SalesData {
    final String country;
    final double totalSales;

    SalesData({
        required this.country,
        required this.totalSales,
    });

    // Factory method buat nge-buat instance dari map (JSON object)
    factory SalesData.fromJson(Map<String, dynamic> json) => SalesData(
        country: json["country"],
        totalSales: double.parse(json["total_sales"]), // Kita parse ke double biar bisa dipake di chart
    );

    // Method buat nge-convert instance ke map
    Map<String, dynamic> toJson() => {
        "country": country,
        "total_sales": totalSales,
    };
}