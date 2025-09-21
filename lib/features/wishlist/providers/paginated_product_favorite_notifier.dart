import 'package:ecommerce/core/models/product_model.dart';
import 'package:ecommerce/core/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/paginated_state.dart';

class PaginatedProductFavoriteNotifier
    extends AsyncNotifier<PaginationState<ProductModel>> {
  @override
  Future<PaginationState<ProductModel>> build() async {
    final repository = ref.read(productRepoProvider);
    final response = await repository.getFavoriteProducts();

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
    await Future.delayed(Duration(seconds: 2));

    final repository = ref.read(productRepoProvider);

    try {
      final response =
          await repository.getFavoriteProducts(url: currentState.nextCursor);
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

final paginatedProductFavoriteNotifier = AsyncNotifierProvider<
    PaginatedProductFavoriteNotifier, PaginationState<ProductModel>>(
  () => PaginatedProductFavoriteNotifier(),
);
