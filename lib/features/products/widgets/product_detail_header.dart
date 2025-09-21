import 'package:ecommerce/core/consts/app_routes.dart';
import 'package:ecommerce/core/helpers/AppHelper.dart';
import 'package:ecommerce/features/products/models/product_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductDetailHeader extends StatelessWidget {
  const ProductDetailHeader({super.key, required this.product});
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
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                context.pushNamed(AppRoutes.storeDetailsScreenName,
                    queryParameters: {
                      "storeId": product.storeId,
                    });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.store, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(product.storeName,
                          style: TextStyle(color: Colors.grey[600]))
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  Text(' ${product.rating.toStringAsFixed(1)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
