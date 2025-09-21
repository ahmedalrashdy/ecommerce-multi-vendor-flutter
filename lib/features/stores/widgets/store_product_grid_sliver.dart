import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/error_viewer.dart';
import '../../../core/widgets/product_card.dart';
import '../providers/store_product_notifier.dart';

class StoreProductGridSliver extends ConsumerWidget {
  final int storeId;
  const StoreProductGridSliver({super.key, required this.storeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(storeProductDetailProvider(storeId));

    // سنستخدم نفس نمط العرض الذي أتقناه
    // 1. حالة التحميل الأولي
    if (state.isLoading && !state.hasValue) {
      return const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()));
    }

    // 2. حالة الخطأ الأولي
    if (state.hasError && !state.hasValue) {
      return SliverToBoxAdapter(
        child: ErrorViewer(
          errorMessage: state.error.toString(),
          onRetry: () => ref.invalidate(storeProductDetailProvider(storeId)),
        ),
      );
    }

    final data = state.value!;

    if (data.items.isEmpty) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
          child: Center(child: Text('لا توجد منتجات في هذه الفئة')),
        ),
      );
    }

    // 3. عرض المحتوى
    return SliverPadding(
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
            return ProductCard(product: product); // إعادة استخدام ProductCard
          },
          childCount: data.items.length,
        ),
      ),
    );
  }
}
