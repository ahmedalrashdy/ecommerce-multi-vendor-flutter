import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/grouped_cart_by_store_model.dart';
import '../providers/cart_notifier.dart';
import 'cart_item.dart';
import 'store_cart_summery.dart';

class StoreCart extends ConsumerWidget {
  final GroupedCartByStoreModel groupedCartByStoreModel;

  const StoreCart({
    super.key,
    required this.groupedCartByStoreModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = groupedCartByStoreModel;
    final notifier = ref.read(cartNotifierProvider.notifier);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      store.logo != null ? NetworkImage(store.logo!) : null,
                  child: store.logo == null ? const Icon(Icons.store) : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    store.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 2,
            color: Colors.grey.shade300,
          ),

          // --- 2. قائمة المنتجات الخاصة بالمتجر ---
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: store.items.length,
            itemBuilder: (context, index) {
              final cartItem = store.items[index];
              return Row(
                children: [
                  if (cartItem.isSelected)
                    Checkbox(
                        value: cartItem.isSelected,
                        onChanged: (value) {
                          notifier.toggleSelectCartItem(store.id, cartItem.id);
                        }),
                  Expanded(
                      child: CartItemCard(
                    item: cartItem,
                    onLogPress: () {
                      notifier.toggleSelectCartItem(store.id, cartItem.id);
                    },
                    onUpdateQuantity: (newQuantity) {
                      notifier.updateQuantity(
                          store.id, cartItem.id, newQuantity);
                    },
                    onDelete: () {
                      notifier.deleteItem(store.id, cartItem.id);
                    },
                  ))
                ],
              );
            },
          ),

          // --- 3. الإجمالي الخاص بالمتجر ---
          StoreCartSummery(store: store)
        ],
      ),
    );
  }
}
