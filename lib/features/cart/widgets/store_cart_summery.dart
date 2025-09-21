import 'package:ecommerce/core/consts/app_routes.dart';
import 'package:ecommerce/features/cart/models/grouped_cart_by_store_model.dart';
import 'package:ecommerce/features/cart/providers/cart_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StoreCartSummery extends ConsumerWidget {
  const StoreCartSummery({
    super.key,
    required this.store,
  });
  final GroupedCartByStoreModel store;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double storeTotal =
        ref.read(cartNotifierProvider.notifier).storeCartTotal(store);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('الإجمالي', style: TextStyle(color: Colors.grey)),
                  Text(
                    '${storeTotal.toStringAsFixed(2)} \$',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  )
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(cartNotifierProvider.notifier).selectStoreCart(store.id);
              context.pushNamed(AppRoutes.userAddressesName,
                  extra: {"from": "cart"});
            },
            child: Text("إتمام الشراء"),
          )
        ],
      ),
    );
  }
}
