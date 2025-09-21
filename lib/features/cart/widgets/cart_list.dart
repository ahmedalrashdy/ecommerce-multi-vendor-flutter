import 'package:ecommerce/features/cart/models/grouped_cart_by_store_model.dart';
import 'package:ecommerce/features/cart/widgets/store_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/paginated_state.dart';
import '../../../core/widgets/error_viewer.dart';
import '../providers/cart_notifier.dart';

class CartList extends ConsumerWidget {
  const CartList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cartNotifierProvider);

    if (state.isLoading && !state.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError && !state.hasValue) {
      return ErrorViewer(
        errorMessage: state.error.toString(),
        onRetry: () => ref.invalidate(cartNotifierProvider),
      );
    }

    return _buildContent(context, ref, state);
  }

  Widget _buildContent(BuildContext context, WidgetRef ref,
      AsyncValue<PaginationState<GroupedCartByStoreModel>> state) {
    final data = state.value!;

    if (data.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined,
                size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text('سلة التسوق فارغة!',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis == Axis.vertical &&
            notification is ScrollUpdateNotification &&
            notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 300) {
          ref.read(cartNotifierProvider.notifier).fetchNextPage();
        }
        return false;
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final storeCart = data.items[index];
                  return StoreCart(
                    groupedCartByStoreModel: storeCart,
                  );
                },
                childCount: data.items.length,
              ),
            ),
          ),
          if (state.isLoading && !data.hasReachedEnd)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          if (state.hasError && state.hasValue)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ErrorViewer(
                  errorMessage: "فشل تحميل المزيد",
                  onRetry: () =>
                      ref.read(cartNotifierProvider.notifier).fetchNextPage(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
