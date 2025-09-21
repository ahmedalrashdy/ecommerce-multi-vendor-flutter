import 'package:ecommerce/core/widgets/tab_content.dart';
import 'package:ecommerce/features/stores/widgets/store_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/enums.dart';
import 'package:ecommerce/core/providers/providers.dart';

import '../../../core/widgets/platform_category_tab_bar.dart';
import '../providers/paginated_stores_notifier.dart';

class StoresListScreen extends ConsumerStatefulWidget {
  const StoresListScreen({super.key});

  @override
  ConsumerState<StoresListScreen> createState() => _StoresListScreenState();
}

class _StoresListScreenState extends ConsumerState<StoresListScreen>
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
      await ref.refresh(paginatedStoresNotifier(platformCategory));
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final platformCategoryAsync = ref.watch(platformCategoryProvider);
    final currentSortBy = ref.watch(storeSortByProvider("stores-list-screen"));
    return platformCategoryAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('المتاجر')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(title: const Text('المتاجر')),
        body: Center(child: Text('حدث خطأ: $error')),
      ),
      data: (categories) {
        final tabCount = categories.pCategories.length + 1;
        _updateTabController(tabCount);
        return Scaffold(
          appBar: AppBar(
            title: const Text('المتاجر'),
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
                        child: StoreGrid(),
                        onRefresh: () async {
                          await _refresh(null);
                        }));
              } else {
                final category = categories.pCategories[index - 1];
                return TabContent(
                    child: RefreshIndicator(
                        child: StoreGrid(platformCategory: category.id),
                        onRefresh: () async {
                          await _refresh(category.id);
                        }));
              }
            }),
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet() {
    final currentSortBy = ref.read(storeSortByProvider("stores-list-screen"));
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        StoreSortBy selectedSortBy = currentSortBy;
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
                  RadioListTile<StoreSortBy>(
                    title: Text(StoreSortBy.topRated.ar),
                    value: StoreSortBy.topRated,
                    groupValue: selectedSortBy,
                    onChanged: (value) =>
                        setModalState(() => selectedSortBy = value!),
                  ),
                  RadioListTile<StoreSortBy>(
                    title: Text(StoreSortBy.recent.ar),
                    value: StoreSortBy.recent,
                    groupValue: selectedSortBy,
                    onChanged: (value) =>
                        setModalState(() => selectedSortBy = value!),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(storeSortByProvider("stores-list-screen")
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
