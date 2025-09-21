import 'package:ecommerce/features/products/models/product_detail_model.dart';
import 'package:flutter/material.dart';

class ProductSpecificationSection extends StatelessWidget {
  const ProductSpecificationSection({super.key, required this.product});
  final ProductDetailModel product;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 8),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Description",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(product.description,
                style: TextStyle(color: Colors.grey[700], height: 1.5)),
            const Divider(height: 32),
            const Text("Specifications",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Simple list of rows for specifications
            ...product.specifications.entries.map((spec) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(spec.key,
                            style: TextStyle(color: Colors.grey[600]))),
                    Expanded(
                        flex: 3,
                        child: Text(spec.value,
                            style:
                                const TextStyle(fontWeight: FontWeight.w500))),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
