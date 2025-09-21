import 'package:flutter/material.dart';
import '../../../core/models/store_detail_model.dart';

class StoreHeaderSliver extends StatelessWidget {
  final StoreDetailModel store;
  const StoreHeaderSliver({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // استخدام SliverToBoxAdapter لتحويل Widget عادي إلى Sliver
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الشعار
                CircleAvatar(
                  radius: 40,
                  backgroundImage: store.logoUrl != null
                      ? NetworkImage(store.logoUrl!)
                      : null,
                  child: store.logoUrl == null
                      ? const Icon(Icons.store, size: 40)
                      : null,
                  backgroundColor: Colors.grey.shade200,
                ),
                const SizedBox(width: 16),
                // الاسم والتقييم
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(store.name,
                          style: textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            store.averageRating.toStringAsFixed(1),
                            style: textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${store.reviewCount} مراجعة)',
                            style: textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // معلومات إضافية (أيقونات ونص)
            _buildInfoRow(Icons.location_on_outlined, store.city),
            const SizedBox(height: 8),
            if (store.openingTime != null)
              _buildInfoRow(Icons.access_time_outlined,
                  'يفتح من ${store.openingTime} إلى ${store.closingTime}'),
            const SizedBox(height: 16),
            // وصف المتجر
            Text(store.description, style: textTheme.bodyMedium),
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }

  // Widget مساعد لإنشاء صف معلومات (أيقونة + نص)
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade700, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
      ],
    );
  }
}
