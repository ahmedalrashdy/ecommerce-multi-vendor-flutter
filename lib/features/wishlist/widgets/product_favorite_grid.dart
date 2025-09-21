// lib/features/wishlist/widgets/product_favorite_grid.dart

import 'package:ecommerce/core/widgets/error_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/product_model.dart';
import '../../../core/providers/paginated_state.dart';
import '../../../core/widgets/product_card.dart';
import '../providers/paginated_product_favorite_notifier.dart';

class ProductFavoriteGrid extends ConsumerWidget {
  const ProductFavoriteGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paginatedProductFavoriteNotifier);

    // 1. حالة التحميل الأولي
    if (state.isLoading && !state.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. حالة الخطأ الأولي
    if (!state.isLoading && state.hasError && !state.hasValue) {
      return ErrorViewer(
        errorMessage: state.error.toString(),
        onRetry: () => ref.invalidate(paginatedProductFavoriteNotifier),
      );
    }

    return _buildContent(context, ref, state);
  }

  Widget _buildContent(BuildContext context, WidgetRef ref,
      AsyncValue<PaginationState<ProductModel>> state) {
    final data = state.value!;

    if (data.items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const Center(child: Text('لا توجد منتجات في المفضلة')),
          ),
        ],
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis == Axis.vertical &&
            notification is ScrollUpdateNotification &&
            notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 300) {
          final notifierState = ref.read(paginatedProductFavoriteNotifier);
          if (!notifierState.isLoading) {
            ref.read(paginatedProductFavoriteNotifier.notifier).fetchNextPage();
          }
        }
        return false;
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 270,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = data.items[index];
                  return ProductCard(product: product);
                },
                childCount: data.items.length,
              ),
            ),
          ),

          // Sliver لعرض مؤشر التحميل للصفحة التالية
          if (state.isLoading && !data.hasReachedEnd)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),

          // Sliver لعرض الخطأ عند فشل تحميل الصفحة التالية
          if (!state.isLoading && state.hasError && state.hasValue)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: ErrorViewer(
                  errorMessage: "فشل تحميل المزيد من المنتجات",
                  onRetry: () => ref
                      .read(paginatedProductFavoriteNotifier.notifier)
                      .fetchNextPage(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
