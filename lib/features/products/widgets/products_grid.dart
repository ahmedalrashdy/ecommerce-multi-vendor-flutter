import 'package:ecommerce/core/widgets/error_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/product_model.dart';
import '../../../core/providers/paginated_state.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/product_card.dart';
import '../providers/products_list_notifier.dart';

class ProductGrid extends ConsumerWidget {
  const ProductGrid({super.key, this.platformCategory});
  final int? platformCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(productSortByProvider("products-list-screen"), (previous, next) {
      if (previous != next) {
        ref.invalidate(paginatedProductsProvider(platformCategory));
      }
    });

    final state = ref.watch(paginatedProductsProvider(platformCategory));

    // الحالة 1: التحميل الأولي
    if (state.isLoading && !state.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }

    // الحالة 2: الخطأ الأولي
    if (!state.isLoading && state.hasError && !state.hasValue) {
      return ErrorViewer(
        errorMessage: state.error.toString(),
        onRetry: () =>
            ref.invalidate(paginatedProductsProvider(platformCategory)),
      );
    }

    // عرض المحتوى
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
            child: const Center(child: Text('لا توجد منتجات في هذا القسم')),
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
          final notifierState =
              ref.read(paginatedProductsProvider(platformCategory));
          if (!notifierState.isLoading) {
            ref
                .read(paginatedProductsProvider(platformCategory).notifier)
                .fetchNextPage();
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
          if (state.hasError && state.hasValue)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: ErrorViewer(
                  errorMessage: "فشل تحميل المزيد من المنتجات",
                  onRetry: () => ref
                      .read(
                          paginatedProductsProvider(platformCategory).notifier)
                      .fetchNextPage(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
