import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_notifier.dart';
import '../widgets/cart_list.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة التسوق'),
      ),
      body: RefreshIndicator(
        child: CartList(),
        onRefresh: () async {
          await ref.refresh(cartNotifierProvider.future);
        },
      ),
    );
  }
}
