// lib/features/products/screens/product_list_screen.dart (افترضت أن الملف هنا)

import 'package:ecommerce/core/enums/enums.dart';
import 'package:ecommerce/core/widgets/tab_content.dart';
import 'package:ecommerce/features/products/providers/products_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/platform_category_tab_bar.dart';
import 'package:ecommerce/core/providers/providers.dart';

import '../widgets/products_grid.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _updateTabController(int length) {
    if (_tabController != null && _tabController!.length != length) {
      _tabController!.dispose();
      _tabController = null;
    }
    _tabController ??= TabController(length: length, vsync: this);
  }

  Future<void> _refresh(int? platformCategory) async {
    try {
      await ref.refresh(paginatedProductsProvider(platformCategory).future);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final platformCategoryAsync = ref.watch(platformCategoryProvider);

    return platformCategoryAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('المنتجات')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(title: const Text('المنتجات')),
        body: Center(child: Text('حدث خطأ: $error')),
      ),
      data: (categories) {
        final tabCount = categories.pCategories.length + 1;
        _updateTabController(tabCount);
        return Scaffold(
          appBar: AppBar(
            title: const Text('المنتجات'),
            elevation: 0,
            bottom: PlatformCategoryTabBar(
              tabController: _tabController!,
              pCategories: categories.pCategories,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showFilterBottomSheet(),
              ),
            ],
          ),
          body: TabBarView(
            controller: _tabController,
            children: List.generate(tabCount, (index) {
              if (index == 0) {
                return TabContent(
                    child: RefreshIndicator(
                        child: ProductGrid(),
                        onRefresh: () async {
                          await _refresh(null);
                        }));
              } else {
                final category = categories.pCategories[index - 1];
                return TabContent(
                  child: RefreshIndicator(
                    child: ProductGrid(platformCategory: category.id),
                    onRefresh: () async {
                      await _refresh(category.id);
                    },
                  ),
                );
              }
            }),
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet() {
    final currentSortBy =
        ref.read(productSortByProvider('products-list-screen'));
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        ProductSortBy selectedSortBy = currentSortBy;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'ترتيب حسب',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  RadioListTile<ProductSortBy>(
                    title: Text(ProductSortBy.topRated.ar),
                    value: ProductSortBy.topRated,
                    groupValue: selectedSortBy,
                    // تحديث الحالة المحلية فقط
                    onChanged: (value) =>
                        setModalState(() => selectedSortBy = value!),
                  ),
                  RadioListTile<ProductSortBy>(
                    title: Text(ProductSortBy.topSale.ar),
                    value: ProductSortBy.topSale,
                    groupValue: selectedSortBy,
                    onChanged: (value) =>
                        setModalState(() => selectedSortBy = value!),
                  ),
                  RadioListTile<ProductSortBy>(
                    title: Text(ProductSortBy.recent.ar),
                    value: ProductSortBy.recent,
                    groupValue: selectedSortBy,
                    onChanged: (value) =>
                        setModalState(() => selectedSortBy = value!),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(productSortByProvider('products-list-screen')
                              .notifier)
                          .state = selectedSortBy;

                      Navigator.pop(context);
                    },
                    child: const Text('تطبيق'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
