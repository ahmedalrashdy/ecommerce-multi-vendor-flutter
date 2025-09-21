import 'package:ecommerce/core/consts/app_routes.dart';
import 'package:ecommerce/core/widgets/result_view.dart';
import 'package:ecommerce/features/main/providers/providers.dart';
import 'package:ecommerce/features/main/widgets/category_filter_chip.dart';
import 'package:ecommerce/core/widgets/product_card.dart';
import 'package:ecommerce/features/main/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'sort_option_chip.dart';

class ProductsSection extends ConsumerWidget {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(featuredProductsProvider);
    final notifier = ref.read(featuredProductsProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SectionHeader(
              title: 'المنتجات المميزة',
              onSeeAllPressed: () =>
                  context.pushNamed(AppRoutes.productsListScreenName),
            ),
          ),
          const SizedBox(height: 8),

          // فلترة الأقسام
          SizedBox(
            height: 40,
            child: ResultView(
              status: state.fetchCategoriesStatus,
              data: state.categories,
              errorMessage: state.fetchCategoriesError,
              successBuilder: (context, data) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length + 1,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return CategoryFilterChip(
                        label: 'الكل',
                        isSelected: state.selectedCategoryId == null,
                        onSelected: (_) => notifier.selectCategory(null),
                      );
                    }
                    final category = data[index - 1];
                    return CategoryFilterChip(
                      label: category.name,
                      isSelected: state.selectedCategoryId == category.id,
                      onSelected: (_) => notifier.selectCategory(category.id),
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // خيارات الترتيب
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text('ترتيب حسب:', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                SortOptionChip(
                  label: 'الأعلى تقييماً',
                  isSelected: state.sortBy == 'rating',
                  onSelected: (_) => notifier.selectSortBy('rating'),
                ),
                const SizedBox(width: 8),
                SortOptionChip(
                  label: 'الأكثر مبيعاً',
                  isSelected: state.sortBy == 'sales',
                  onSelected: (_) => notifier.selectSortBy('sales'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          // عرض المنتجات والتحميل المتتالي
          ResultView(
            status: state.fetchProductsStatus,
            data: state.paginatedResponse,
            errorMessage: state.fetchProductsError,
            successBuilder: (context, paginatedData) {
              final products = paginatedData.results;
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 275,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: products.length,
                    itemBuilder: (context, index) =>
                        ProductCard(product: products[index]),
                  ),
                  if (state.isLoadingMore)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
