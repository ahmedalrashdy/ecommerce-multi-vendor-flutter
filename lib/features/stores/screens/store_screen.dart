import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/error_viewer.dart';
import '../../wishlist/providers/store_wishlist_notifier.dart';
import '../providers/providers.dart';
import '../providers/store_product_notifier.dart';
import '../widgets/product_categories_sliver.dart';
import '../widgets/store_header.dart';
import '../widgets/store_product_grid_sliver.dart';

class StoreScreen extends ConsumerWidget {
  final int storeId;
  const StoreScreen({super.key, required this.storeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeDetailAsync = ref.watch(storeDetailProvider(storeId));
    final categoriesAsync = ref.watch(storeProductCategoriesProvider(storeId));
    return Scaffold(
      body: storeDetailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorViewer(
          errorMessage: error.toString(),
          onRetry: () => ref.invalidate(storeDetailProvider(storeId)),
        ),
        data: (store) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                stretch: true,
                backgroundColor: Theme.of(context).cardColor,
                elevation: 2,
                title: Text(store.name),
                actions: [
                  Consumer(
                    builder: (context, ref, _) {
                      final isFavorite =
                          ref.watch(isStoreFavoriteProvider(store.id));
                      final wishlistNotifier =
                          ref.read(storeWishlistNotifierProvider.notifier);

                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                        onPressed: () =>
                            wishlistNotifier.toggleFavorite(store.id),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {},
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    store.coverImageUrl ??
                        'https://via.placeholder.com/600x300',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey.shade300),
                  ),
                ),
              ),
              StoreHeaderSliver(store: store),
              categoriesAsync.when(
                loading: () => const SliverToBoxAdapter(
                    child: SizedBox(
                        height: 60,
                        child: Center(child: CircularProgressIndicator()))),
                error: (e, st) => SliverToBoxAdapter(
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("فشل تحميل الفئات"))),
                data: (categories) =>
                    ProductCategoriesSliver(categories: categories),
              ),
              StoreProductGridSliver(storeId: storeId),
              Consumer(builder: (context, ref, _) {
                final productsState =
                    ref.watch(storeProductDetailProvider(storeId));
                final productsData = productsState.value;

                if (productsState.isLoading &&
                    productsData != null &&
                    !productsData.hasReachedEnd) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }
                if (productsState.hasError && productsState.hasValue) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ErrorViewer(
                        errorMessage: "فشل تحميل المزيد",
                        onRetry: () => ref
                            .read(storeProductDetailProvider(storeId).notifier)
                            .fetchNextPage(),
                      ),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }),
            ],
          );
        },
      ),
    );
  }
}
