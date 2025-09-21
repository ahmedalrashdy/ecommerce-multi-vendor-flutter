import 'dart:async';
import 'package:ecommerce/core/widgets/tab_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/product_search_notifier.dart';
import '../providers/store_search_notifier.dart';
import '../widgets/product_search_results_view.dart';
import '../widgets/store_search_results_views.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Timer? _productDebounce;
  Timer? _storeDebounce;
  String? productPrevQuery;
  String? storePrevQuery;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_searchTrigger);
    _tabController.addListener(() {
      _focusNode.unfocus();
      _searchTrigger();
    });
  }

  void _searchTrigger() {
    final query = _searchController.text.trim();
    if (_tabController.index == 0) {
      if (query.isEmpty || query == productPrevQuery) return;
      productPrevQuery = query;
      if (_productDebounce?.isActive ?? false) _productDebounce!.cancel();
      _productDebounce = Timer(const Duration(milliseconds: 500), () {
        ref.read(productSearchProvider.notifier).searchProducts(query);
      });
    } else {
      if (query.isEmpty || query == storePrevQuery) return;
      storePrevQuery = query;
      if (_storeDebounce?.isActive ?? false) _storeDebounce!.cancel();
      _storeDebounce = Timer(const Duration(milliseconds: 500), () {
        ref.read(storeSearchProvider.notifier).searchStores(query);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _productDebounce?.cancel();
    _storeDebounce?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: SearchInputField(
            tabController: _tabController,
            searchController: _searchController,
            focusNode: _focusNode,
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'المنتجات'),
              Tab(text: 'المتاجر'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            TabContent(
              child: RefreshIndicator(
                onRefresh: () async {
                  try {
                    await ref.read(productSearchProvider.notifier).refresh();
                  } catch (_) {}
                },
                child: const ProductSearchResultsView(),
              ),
            ),
            TabContent(
              child: RefreshIndicator(
                onRefresh: () async {
                  try {
                    await ref.read(storeSearchProvider.notifier).refresh();
                  } catch (_) {}
                },
                child: const StoreSearchResultsView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchInputField extends ConsumerWidget {
  const SearchInputField({
    super.key,
    required this.tabController,
    required this.searchController,
    required this.focusNode,
  });

  final TabController tabController;
  final TextEditingController searchController;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: searchController,
      builder: (context, value, _) {
        return TextField(
          controller: searchController,
          focusNode: focusNode,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'ابحث عن منتج أو متجر...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      if (tabController.index == 0) {
                        ref.invalidate(productSearchProvider);
                      } else {
                        ref.invalidate(storeSearchProvider);
                      }
                    },
                  )
                : null,
            border: InputBorder.none,
            filled: false,
          ),
          textInputAction: TextInputAction.search,
        );
      },
    );
  }
}
