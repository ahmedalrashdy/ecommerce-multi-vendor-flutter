import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import 'package:ecommerce/core/widgets/tab_content.dart';
import 'package:ecommerce/features/wishlist/providers/paginated_product_favorite_notifier.dart';
import 'package:ecommerce/features/wishlist/providers/paginated_store_favorite_notifier.dart';
import 'package:ecommerce/features/wishlist/widgets/store_favorite_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/product_favorite_grid.dart';

class WishlistScreen extends ConsumerStatefulWidget {
  const WishlistScreen({super.key});

  @override
  ConsumerState<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends ConsumerState<WishlistScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _onRefresh() async {
    try {
      if (_tabController.index == 0) {
        await ref.refresh(paginatedProductFavoriteNotifier.future);
      } else {
        // Refresh المتاجر
        await ref.refresh(paginatedStoreFavoriteNotifier.future);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "المفضلة",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        bottom: _buildAppBar(),
        elevation: 8,
        backgroundColor: context.colors.surface,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TabContent(
              child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: const ProductFavoriteGrid(),
          )),
          TabContent(
              child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: const StoreFavoriteGrid(),
          )),
        ],
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: TabBar(
          isScrollable: false,
          controller: _tabController,
          // tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: "المنتجات"),
            Tab(text: "المتاجر"),
          ],
          unselectedLabelColor: context.colors.primary,
          labelColor: context.colors.onPrimary,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            color: context.colors.primary,
          ),
          labelStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
