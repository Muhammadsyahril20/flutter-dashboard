// lib/models/segment_profit_data.dart

import 'dart:convert';

// Function to parse the list of SegmentProfitData from a JSON string
List<SegmentProfitData> segmentProfitDataFromJson(String str) => 
    List<SegmentProfitData>.from(json.decode(str).map((x) => SegmentProfitData.fromJson(x)));

// Function to convert a list of SegmentProfitData to a JSON string
String segmentProfitDataToJson(List<SegmentProfitData> data) => 
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// Model class for a single segment's profit data
class SegmentProfitData {
    final String segment;
    final double totalProfit;

    SegmentProfitData({
        required this.segment,
        required this.totalProfit,
    });

    // Factory constructor to create an instance from a JSON object
    factory SegmentProfitData.fromJson(Map<String, dynamic> json) => SegmentProfitData(
        segment: json["segment"],
        // The API returns total_profit as a string, so we need to parse it to a double
        totalProfit: double.parse(json["total_profit"]),
    );

    // Method to convert an instance to a JSON object
    Map<String, dynamic> toJson() => {
        "segment": segment,
        "total_profit": totalProfit,
    };
}
