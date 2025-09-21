import 'package:ecommerce/features/stores/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/product_model.dart';
import '../../../core/providers/paginated_state.dart';
import '../../../core/providers/providers.dart';

class StoreProductDetailNotifier
    extends AutoDisposeFamilyAsyncNotifier<PaginationState<ProductModel>, int> {
  @override
  Future<PaginationState<ProductModel>> build(int storeId) async {
    final parentCategoryId = ref.watch(selectedStoreParentCategoryProvider);
    final childCategoryId = ref.watch(selectedStoreChildCategoryProvider);

    final activeCategoryId = childCategoryId ?? parentCategoryId;

    final response = await ref.read(productRepoProvider).getStoreProducts(
          storeId: storeId,
          categoryId: activeCategoryId,
        );
    return PaginationState(
      items: response.results,
      nextCursor: response.next,
      hasReachedEnd: response.next == null,
    );
  }

  Future<void> fetchNextPage() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.hasReachedEnd || state.isLoading)
      return;

    state =
        AsyncLoading<PaginationState<ProductModel>>().copyWithPrevious(state);

    final storeId = arg;

    try {
      final response = await ref.read(productRepoProvider).getStoreProducts(
            url: currentState.nextCursor,
            storeId: storeId,
          );
      state = AsyncData(currentState.copyWith(
        items: [...currentState.items, ...response.results],
        nextCursor: response.next,
        hasReachedEnd: response.next == null,
      ));
    } catch (e, st) {
      state = AsyncError<PaginationState<ProductModel>>(e, st)
          .copyWithPrevious(state);
    }
  }
}

final storeProductDetailProvider = AutoDisposeAsyncNotifierProvider.family<
    StoreProductDetailNotifier, PaginationState<ProductModel>, int>(
  () {
    return StoreProductDetailNotifier();
  },
);
