import 'package:ecommerce/core/widgets/custom_confirm_diolog.dart';
import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final Function(int newQuantity) onUpdateQuantity;
  final VoidCallback onDelete;
  final VoidCallback onLogPress;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onUpdateQuantity,
    required this.onDelete,
    required this.onLogPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onLongPress: onLogPress,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 1,
          color: Colors.grey.shade300,
        ))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                item.imageUrl ?? 'https://via.placeholder.com/150',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, size: 90),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (item.options.isNotEmpty)
                    Text(
                      _formatOptions(item.options),
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.grey.shade600),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    '${item.price.toStringAsFixed(2)} \$',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // أزرار التحكم
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      color: theme.colorScheme.error),
                  onPressed: item.isUpdating
                      ? null
                      : () {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return CustomConfirmationDialog(
                                  title: "حذف المنتج من السلة",
                                  content:
                                      "هل انت متأكد من حذف المنتج من السلة ",
                                  isDestructive: true,
                                  onConfirm: () {
                                    onDelete();
                                  },
                                );
                              });
                        },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(height: 16),
                _buildQuantityStepper(),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _formatOptions(Map<String, dynamic> options) {
    return options.entries.map((e) => '${e.key}: ${e.value}').join(', ');
  }

  Widget _buildQuantityStepper() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            // تعطيل الزر إذا كان العنصر قيد التحديث
            onPressed: (item.quantity > 1 && !item.isUpdating)
                ? () => onUpdateQuantity(item.quantity - 1)
                : null,
            icon: const Icon(Icons.remove, size: 18),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            constraints: const BoxConstraints(),
          ),
          Text(
            item.quantity.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          IconButton(
            onPressed: !item.isUpdating
                ? () => onUpdateQuantity(item.quantity + 1)
                : null,
            icon: const Icon(Icons.add, size: 18),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
