import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/core/consts/app_routes.dart';
import 'package:ecommerce/core/extensions/app_colors_extension.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import 'package:ecommerce/core/widgets/store_chip_widget.dart';
import 'package:ecommerce/core/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/wishlist/providers/product_wishlist_notifier.dart';

class ProductCard extends ConsumerWidget {
  final ProductModel product;
  final bool showStoreBanner;
  const ProductCard({
    super.key,
    required this.product,
    this.showStoreBanner = true,
  });

  @override
  Widget build(BuildContext context, ref) {
    final appColors = context.colors;
    final isFavorite = ref.watch(isFavoriteProvider(product.id));
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRoutes.productDetailsScreenName, pathParameters: {
          "productId": product.id.toString(),
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: appColors.card,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  ),
                  if (product.discountPercentage > 0) _buildDiscount(),
                  if (showStoreBanner)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: StoreBannerWidget(storeName: product.storeName),
                    ),
                ],
              ),
            ),
            // تفاصيل المنتج
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  _buildPriceSection(appColors),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating}',
                        style: TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      GestureDetector(
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 22,
                          color:
                              isFavorite ? Colors.red : appColors.secondaryText,
                        ),
                        onTap: () {
                          ref
                              .read(productWishlistNotifierProvider.notifier)
                              .toggleFavorite(product.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection(AppColorsExtension appColors) {
    return Row(
      children: [
        Text(
          '${product.finalPrice} ر.س',
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        if (product.discountPercentage > 0) ...[
          const SizedBox(width: 5),
          Text(
            '${product.price} ر.س',
            style: TextStyle(
              decoration: TextDecoration.lineThrough,
              color: appColors.secondaryText,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ],
    );
  }

  Widget _buildDiscount() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '${product.discountPercentage}%',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
