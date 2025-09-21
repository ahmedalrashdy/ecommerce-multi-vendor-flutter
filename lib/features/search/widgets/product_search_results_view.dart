import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/product_card.dart';
import '../providers/product_search_notifier.dart';

class ProductSearchResultsView extends ConsumerStatefulWidget {
  const ProductSearchResultsView({super.key});

  @override
  ConsumerState<ProductSearchResultsView> createState() =>
      _ProductSearchResultsViewState();
}

class _ProductSearchResultsViewState
    extends ConsumerState<ProductSearchResultsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(productSearchProvider.notifier).fetchNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(productSearchProvider);
    final products = searchState.items;

    if (searchState.isFirstFetch && searchState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchState.error != null && products.isEmpty) {
      return Center(child: Text('حدث خطأ: ${searchState.error}'));
    }

    if (products.isEmpty && !searchState.isLoading) {
      return const Center(
        child: Text(
          'لا توجد نتائج بحث. \n ابدأ بالكتابة في شريط البحث أعلاه.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ProductCard(product: products[index]);
              },
              childCount: products.length,
            ),
          ),
        ),
        // مؤشر التحميل عند جلب الصفحة التالية
        if (searchState.isLoading && !searchState.isFirstFetch)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
