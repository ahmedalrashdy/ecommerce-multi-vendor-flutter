import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cart/models/cart_item_model.dart';
import '../../cart/models/grouped_cart_by_store_model.dart';
import '../../cart/providers/cart_notifier.dart';

class ProductsSummaryList extends ConsumerWidget {
  const ProductsSummaryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartNotifierProvider);
    final selectedStoreId = cartState.value?.selectedStoreCartId;

    if (cartState.value == null || selectedStoreId == null) {
      return const SizedBox.shrink();
    }

    final storeCart = cartState.value!.items.firstWhere(
      (store) => store.id == selectedStoreId,
    );

    final itemsToDisplay = _getDisplayItems(storeCart);
    final storeTotal =
        ref.read(cartNotifierProvider.notifier).storeCartTotal(storeCart);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 3. تحسين رأس القسم ---
            Row(
              children: [
                Icon(Icons.shopping_basket_outlined, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'ملخص الطلب من "${storeCart.name}"',
                  style: textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),

            // --- 4. استخدام ListView لعرض المنتجات ---
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemsToDisplay.length,
              itemBuilder: (context, index) {
                return _buildProductRow(context, itemsToDisplay[index]);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),

            // --- 5. تحسين عرض الإجمالي ---
            _buildTotalRow("المجموع الجزئي", money(storeTotal)),
            // يمكنك إضافة صفوف أخرى هنا للشحن، الخصم، إلخ.
            // _buildTotalRow("رسوم التوصيل", money(10.00)),
            // const SizedBox(height: 8),
            // _buildTotalRow("الإجمالي النهائي", money(storeTotal + 10.00), isTotal: true),
          ],
        ),
      ),
    );
  }

  List<CartItemModel> _getDisplayItems(GroupedCartByStoreModel storeCart) {
    final selectedItems =
        storeCart.items.where((item) => item.isSelected).toList();
    return selectedItems.isNotEmpty ? selectedItems : storeCart.items;
  }

  // دالة مساعدة لتنسيق العملة
  String money(double v) => '${v.toStringAsFixed(2)} \$';

  Widget _buildProductRow(BuildContext context, CartItemModel p) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                p.imageUrl ?? 'https://via.placeholder.com/150',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                    width: 60, height: 60, color: Colors.grey.shade200),
              ),
            ),
            Positioned(
              top: -5,
              right: -5,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  '${p.quantity}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
        const SizedBox(width: 12),

        // --- اسم المنتج وخياراته ---
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                p.productName,
                style:
                    textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (p.options.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    p.options.entries
                        .map((e) => e.value.toString())
                        .join(' / '),
                    style: textTheme.bodySmall
                        ?.copyWith(color: Colors.grey.shade600),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        Text(
          money(p.quantity * p.price),
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTotalRow(String title, String value, {bool isTotal = false}) {
    final textStyle = TextStyle(
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
      fontSize: isTotal ? 16 : 14,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: textStyle),
          Text(value, style: textStyle),
        ],
      ),
    );
  }
}
