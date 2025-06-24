// lib/widgets/top_products_list.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/top_product.dart';

class TopProductsList extends StatelessWidget {
  final List<TopProductData> products;

  const TopProductsList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text("No product data."));
    }

    // Find the maximum value to create a proportional bar
    final maxUnits = products.map((p) => p.totalUnits).reduce((a, b) => a > b ? a : b);

    // Using ListView.builder for performance with long lists
    return ListView.builder(
      // These properties are important when putting a ListView inside a SingleChildScrollView
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final barWidthFactor = product.totalUnits / maxUnits;
        
        // Format the number for display
        final formattedUnits = NumberFormat.compact().format(product.totalUnits);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              // Product Name
              SizedBox(
                width: 80, // Fixed width for product names for alignment
                child: Text(
                  product.product,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              // Proportional Bar
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        Container(
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Container(
                          height: 24,
                          width: constraints.maxWidth * barWidthFactor,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.green, Colors.teal],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }
                ),
              ),
              const SizedBox(width: 8),
              // Total Units Text
              SizedBox(
                width: 50,
                child: Text(
                  formattedUnits,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
