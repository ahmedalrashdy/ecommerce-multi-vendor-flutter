import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import 'package:ecommerce/features/products/models/product_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../wishlist/providers/product_wishlist_notifier.dart';

class ProductDetailAppBar extends ConsumerWidget {
  const ProductDetailAppBar({super.key, required this.product});
  final ProductDetailModel product;
  @override
  Widget build(BuildContext context, ref) {
    final isFavorite = ref.watch(isFavoriteProvider(product.id));
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context)),
      title: Text(product.name,
          style: const TextStyle(color: Colors.black, fontSize: 18)),
      actions: [
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            size: 22,
            color: isFavorite ? Colors.red : context.colors.secondaryText,
          ),
          onPressed: () {
            ref
                .read(productWishlistNotifierProvider.notifier)
                .toggleFavorite(product.id);
          },
        ),
        IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {}),
      ],
    );
  }
}
