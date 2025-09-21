// lib/features/stores/widgets/store_grid.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/error_viewer.dart';
import '../../../core/models/store_model.dart';
import '../../../core/providers/paginated_state.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/store_card.dart';
import '../providers/paginated_stores_notifier.dart';

class StoreGrid extends ConsumerWidget {
  const StoreGrid({super.key, this.platformCategory});
  final int? platformCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // الاستماع لتغير الفلتر لإعادة تحميل البيانات
    ref.listen(storeSortByProvider("stores-list-screen"), (previous, next) {
      if (previous != next) {
        ref.invalidate(paginatedStoresNotifier(platformCategory));
      }
    });

    final state = ref.watch(paginatedStoresNotifier(platformCategory));

    // الحالة 1: التحميل الأولي
    if (state.isLoading && !state.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }

    // الحالة 2: الخطأ الأولي
    if (state.hasError && !state.hasValue) {
      return ErrorViewer(
        errorMessage: state.error.toString(),
        onRetry: () =>
            ref.invalidate(paginatedStoresNotifier(platformCategory)),
      );
    }

    // عرض المحتوى
    return _buildContent(context, ref, state);
  }

  Widget _buildContent(BuildContext context, WidgetRef ref,
      AsyncValue<PaginationState<StoreModel>> state) {
    final data = state.value!;

    if (data.items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const Center(child: Text('لا توجد متاجر في هذا القسم')),
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
              ref.read(paginatedStoresNotifier(platformCategory));
          if (!notifierState.isLoading) {
            ref
                .read(paginatedStoresNotifier(platformCategory).notifier)
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
                mainAxisExtent: 200, // الارتفاع المناسب لبطاقة المتجر
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final store = data.items[index];
                  return StoreCard(store: store);
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
                  errorMessage: "فشل تحميل المزيد من المتاجر",
                  onRetry: () => ref
                      .read(paginatedStoresNotifier(platformCategory).notifier)
                      .fetchNextPage(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
