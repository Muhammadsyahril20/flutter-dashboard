import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:business_analytics_app/main.dart';

void main() {
  testWidgets('MyApp renders AnalyticsScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Business Analytics'), findsOneWidget);
  });
}