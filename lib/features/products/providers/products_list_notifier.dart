import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/product_model.dart';
import '../../../core/providers/paginated_state.dart';
import '../../../core/providers/providers.dart';

class PaginatedProductsNotifier extends AutoDisposeFamilyAsyncNotifier<
    PaginationState<ProductModel>, int?> {
  @override
  Future<PaginationState<ProductModel>> build(int? categoryId) async {
    final sortBy = ref.read(productSortByProvider('products-list-screen'));
    final repository = ref.read(productRepoProvider);
    final response = await repository.getFeaturedProducts(params: {
      if (categoryId != null) "": categoryId.toString(),
      "sort-by": sortBy.searchValue,
    });

    return PaginationState<ProductModel>(
      items: response.results,
      nextCursor: response.next,
      hasReachedEnd: response.next == null,
    );
  }

  Future<void> fetchNextPage() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.hasReachedEnd || state.isLoading) {
      return;
    }

    state = const AsyncLoading<PaginationState<ProductModel>>()
        .copyWithPrevious(state);

    final repository = ref.read(productRepoProvider);

    try {
      final response =
          await repository.getFeaturedProducts(url: currentState.nextCursor);
      state = AsyncData(
        currentState.copyWith(
          items: [...currentState.items, ...response.results],
          nextCursor: response.next,
          hasReachedEnd: response.next == null,
          setNextCursorToNull: response.next == null,
        ),
      );
    } catch (e, st) {
      state = AsyncError<PaginationState<ProductModel>>(e, st)
          .copyWithPrevious(state);
    }
  }
}

final paginatedProductsProvider = AsyncNotifierProvider.autoDispose
    .family<PaginatedProductsNotifier, PaginationState<ProductModel>, int?>(
  () => PaginatedProductsNotifier(),
);
