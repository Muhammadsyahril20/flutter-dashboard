// lib/models/profit_data.dart

import 'dart:convert';

List<ProfitData> profitDataFromJson(String str) => List<ProfitData>.from(json.decode(str).map((x) => ProfitData.fromJson(x)));

String profitDataToJson(List<ProfitData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProfitData {
    final String monthName;
    final int year;
    final double totalProfit;

    ProfitData({
        required this.monthName,
        required this.year,
        required this.totalProfit,
    });

    factory ProfitData.fromJson(Map<String, dynamic> json) => ProfitData(
        // Trim spasi yang ga perlu dari nama bulan
        monthName: json["month_name"].toString().trim(), 
        year: json["year"],
        // Parse string profit ke double
        totalProfit: double.parse(json["total_profit"]),
    );

    Map<String, dynamic> toJson() => {
        "month_name": monthName,
        "year": year,
        "total_profit": totalProfit,
    };
}