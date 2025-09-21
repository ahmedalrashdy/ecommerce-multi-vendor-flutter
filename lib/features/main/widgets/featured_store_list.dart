import 'package:ecommerce/features/main/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/error_viewer.dart';
import '../../../core/widgets/store_card.dart';

class FeaturedStoreList extends ConsumerWidget {
  const FeaturedStoreList({super.key, this.platformCategoryId});
  final int? platformCategoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredStoresAsync =
        ref.watch(featuredStoresProvider(platformCategoryId));

    return SizedBox(
      height: 190,
      child: featuredStoresAsync.when(
        data: (stores) {
          if (stores.isEmpty) {
            return const Center(
              child: Text('لا توجد متاجر في هذا القسم'),
            );
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: stores.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final store = stores[index];
              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: StoreCard(store: store));
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorViewer(
          errorMessage: error.toString(),
          onRetry: () =>
              ref.invalidate(featuredStoresProvider(platformCategoryId)),
        ),
      ),
    );
  }
}
