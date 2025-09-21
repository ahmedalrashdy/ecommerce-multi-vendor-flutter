import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../core/models/product_category_model.dart';
import '../providers/providers.dart';

class ProductCategoriesSliver extends ConsumerStatefulWidget {
  final List<ProductCategoryModel> categories;
  const ProductCategoriesSliver({super.key, required this.categories});

  @override
  ConsumerState<ProductCategoriesSliver> createState() =>
      _ProductCategoriesSliverState();
}

class _ProductCategoriesSliverState
    extends ConsumerState<ProductCategoriesSliver>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    // +1 لتبويب "الكل"
    _tabController =
        TabController(length: widget.categories.length + 1, vsync: this);
    _tabController!.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    _tabController?.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController!.indexIsChanging) return;

    final notifier = ref.read(selectedStoreParentCategoryProvider.notifier);
    if (_tabController!.index == 0) {
      notifier.state = null; // "الكل"
    } else {
      notifier.state = widget.categories[_tabController!.index - 1].id;
    }
  }

  @override
  Widget build(BuildContext context) {
    // مشاهدة الفئة الرئيسية المختارة لعرض الفئات الفرعية
    final selectedParentCategoryId =
        ref.watch(selectedStoreParentCategoryProvider);
    final childCategories = widget.categories
        .firstWhereOrNull((cate) => cate.id == selectedParentCategoryId)
        ?.children;

    return MultiSliver(
      children: [
        SliverPinnedHeader(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: [
                const Tab(text: "الكل"),
                ...widget.categories.map((cat) => Tab(text: cat.name)).toList(),
              ],
            ),
          ),
        ),

        // 2. الشريط (غير اللاصق) للفئات الفرعية (يظهر فقط إذا كانت هناك فئات فرعية)
        if (childCategories?.isNotEmpty == true)
          SliverToBoxAdapter(
            child: _buildChildCategoryChips(context, ref, childCategories!),
          ),
      ],
    );
  }

  // Widget مساعد لعرض الفئات الفرعية
  Widget _buildChildCategoryChips(BuildContext context, WidgetRef ref,
      List<ProductCategoryModel> categories) {
    final selectedChildId = ref.watch(selectedStoreChildCategoryProvider);
    final notifier = ref.read(selectedStoreChildCategoryProvider.notifier);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context)
          .scaffoldBackgroundColor
          .withAlpha(240), // لون خلفية شبه شفاف
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildChip(context, "الكل", selectedChildId == null,
                () => notifier.state = null);
          }
          final category = categories[index - 1];
          return _buildChip(
              context,
              category.name,
              selectedChildId == category.id,
              () => notifier.state = category.id);
        },
      ),
    );
  }

  // نفس الـ Widget المساعد من قبل
  Widget _buildChip(BuildContext context, String label, bool isSelected,
      VoidCallback onSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ActionChip(
        label: Text(label),
        onPressed: onSelected,
        backgroundColor: isSelected
            ? Theme.of(context).primaryColor.withOpacity(0.8)
            : Colors.grey.shade200,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
