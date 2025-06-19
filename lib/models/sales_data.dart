class SalesData {
  final String date;
  final String month;
  final String year;
  final String product;
  final String city;
  final double sales;
  final double profit;
  final double categoryShare;

  SalesData({
    required this.date,
    required this.month,
    required this.year,
    required this.product,
    required this.city,
    required this.sales,
    required this.profit,
    required this.categoryShare,
  });

  get value => null;
}

List<SalesData> dummyData = [
  SalesData(date: '1', month: 'Jan', year: '2025', product: 'Electronics', city: 'Jakarta', sales: 10, profit: 5, categoryShare: 25),
  SalesData(date: '2', month: 'Jan', year: '2025', product: 'Clothing', city: 'Bandung', sales: 15, profit: 8, categoryShare: 30),
  SalesData(date: '3', month: 'Feb', year: '2025', product: 'Food', city: 'Surabaya', sales: 13, profit: 6, categoryShare: 20),
  SalesData(date: '4', month: 'Feb', year: '2024', product: 'Electronics', city: 'Jakarta', sales: 17, profit: 10, categoryShare: 15),
  SalesData(date: '5', month: 'Mar', year: '2024', product: 'Clothing', city: 'Bandung', sales: 12, profit: 7, categoryShare: 10),
];