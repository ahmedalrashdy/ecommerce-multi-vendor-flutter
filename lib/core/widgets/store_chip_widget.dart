import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';

class StoreBannerWidget extends StatelessWidget {
  const StoreBannerWidget({super.key, required this.storeName});
  final String storeName;
  @override
  Widget build(BuildContext context) {
    final appColors = context.colors;
    return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: appColors.background.withOpacity(0.8),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(
              Icons.store,
              size: 12,
              color: appColors.primary,
            ),
            const SizedBox(width: 4),
            Text(
              storeName,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ));
  }
}
