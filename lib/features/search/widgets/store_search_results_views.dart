import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/store_card.dart';
import '../providers/store_search_notifier.dart';

class StoreSearchResultsView extends ConsumerStatefulWidget {
  const StoreSearchResultsView({super.key});

  @override
  ConsumerState<StoreSearchResultsView> createState() =>
      _StoreSearchResultsViewState();
}

class _StoreSearchResultsViewState
    extends ConsumerState<StoreSearchResultsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(storeSearchProvider.notifier).fetchNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // مراقبة حالة البحث عن المتاجر
    final searchState = ref.watch(storeSearchProvider);
    final stores = searchState.items;

    // 1. حالة التحميل الأولية (عند أول بحث)
    if (searchState.isFirstFetch && searchState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. حالة وجود خطأ وعدم وجود بيانات لعرضها
    if (searchState.error != null && stores.isEmpty) {
      return Center(
        child: Text(
          'حدث خطأ أثناء البحث.\nيرجى المحاولة مرة أخرى.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    // 3. حالة عدم وجود نتائج للبحث
    if (stores.isEmpty && !searchState.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'لم يتم العثور على متاجر',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'جرّب كلمة بحث مختلفة.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // 4. حالة عرض النتائج
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // استخدام الـ StoreCard الموجودة لديك لعرض كل متجر
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: StoreCard(store: stores[index]),
                );
              },
              childCount: stores.length,
            ),
          ),
        ),

        // عرض مؤشر تحميل في نهاية القائمة عند جلب صفحات إضافية
        if (searchState.isLoading && !searchState.isFirstFetch)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
