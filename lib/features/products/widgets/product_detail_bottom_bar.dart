import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import 'package:ecommerce/features/cart/models/grouped_cart_by_store_model.dart';
import 'package:ecommerce/features/cart/providers/cart_notifier.dart';
import 'package:ecommerce/features/products/models/product_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/paginated_state.dart';
import '../../../core/widgets/custom_confirm_diolog.dart';
import '../../cart/models/cart_item_model.dart';

class ProductDetailBottomBar extends ConsumerWidget {
  const ProductDetailBottomBar({super.key, required this.selectedVariant});
  final ProductVariantModel selectedVariant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartNotifierProvider);

    final cartItem = _findCartItemInState(cartState, selectedVariant.id);
    final isInCart = cartItem != null;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
            .copyWith(bottom: MediaQuery.of(context).padding.bottom + 12),
        decoration: BoxDecoration(
          color: context.colors.surface,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Price",
                    style: TextStyle(
                      fontSize: 14,
                      color: context.colors.secondaryText,
                    )),
                Text(
                  "\$${selectedVariant.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
              ],
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: isInCart
                  ? _buildQuantityStepper(
                      key: ValueKey('stepper_${cartItem.id}'),
                      context: context,
                      ref: ref,
                      cartItem: cartItem,
                    )
                  : _buildAddToCartButton(
                      key: ValueKey('button_${selectedVariant.id}'),
                      context: context,
                      ref: ref,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  CartItemModel? _findCartItemInState(
      AsyncValue<PaginationState<GroupedCartByStoreModel>> state,
      int variantId) {
    if (!state.hasValue) return null;
    CartItemModel? cartItem;
    for (var groupedStoreCart in state.value!.items) {
      for (var item in groupedStoreCart.items) {
        if (item.variantId == variantId) cartItem = item;
      }
    }
    return cartItem;
  }

  Widget _buildAddToCartButton({
    required Key key,
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final isAdding = ref.watch(cartNotifierProvider).isLoading;
    return ElevatedButton.icon(
      key: key,
      onPressed: isAdding
          ? null
          : () {
              ref.read(cartNotifierProvider.notifier).addItem(
                    variantId: selectedVariant.id,
                    quantity: 1,
                  );
            },
      icon: const Icon(Icons.shopping_cart_outlined),
      label: Text(
        "Add to Cart",
        style: TextStyle(
          color: context.colors.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: context.colors.primary,
      ),
    );
  }

  // Widget مساعد لعداد الكمية
  Widget _buildQuantityStepper({
    required Key key,
    required BuildContext context,
    required WidgetRef ref,
    required CartItemModel cartItem,
  }) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        color: context.colors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: cartItem.isUpdating
                ? null
                : () {
                    if (cartItem.quantity == 1) {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return CustomConfirmationDialog(
                              title: "حذف المنتج من السلة",
                              content: "هل انت متأكد من حذف المنتج من السلة ",
                              isDestructive: true,
                              onConfirm: () {
                                ref
                                    .read(cartNotifierProvider.notifier)
                                    .deleteItem(cartItem.storeId, cartItem.id);
                              },
                            );
                          });
                    } else {
                      ref.read(cartNotifierProvider.notifier).updateQuantity(
                            cartItem.storeId,
                            cartItem.id,
                            cartItem.quantity - 1,
                          );
                    }
                  },
            icon: Icon(
              cartItem.quantity == 1 ? Icons.delete_outline : Icons.remove,
              color: context.colors.primary,
            ),
          ),
          cartItem.isUpdating
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : Text(
                  cartItem.quantity.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
          IconButton(
            onPressed: cartItem.isUpdating
                ? null
                : () {
                    ref.read(cartNotifierProvider.notifier).updateQuantity(
                          cartItem.storeId,
                          cartItem.id,
                          cartItem.quantity + 1,
                        );
                  },
            icon: Icon(Icons.add, color: context.colors.primary),
          ),
        ],
      ),
    );
  }
}
