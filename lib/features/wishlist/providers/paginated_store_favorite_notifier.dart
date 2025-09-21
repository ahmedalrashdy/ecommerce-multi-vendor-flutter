import 'package:ecommerce/core/models/store_model.dart';
import 'package:ecommerce/core/repos/wishlist_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/paginated_state.dart';

class PaginatedStoreFavoriteNotifier
    extends AsyncNotifier<PaginationState<StoreModel>> {
  @override
  Future<PaginationState<StoreModel>> build() async {
    final repository = ref.read(wishlistRepoProvider);
    final response = await repository.getFavoriteStores();
    return PaginationState<StoreModel>(
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

    state = const AsyncLoading<PaginationState<StoreModel>>()
        .copyWithPrevious(state);

    final repository = ref.read(wishlistRepoProvider);

    try {
      final response =
          await repository.getFavoriteStores(url: currentState.nextCursor);
      state = AsyncData(
        currentState.copyWith(
          items: [...currentState.items, ...response.results],
          nextCursor: response.next,
          hasReachedEnd: response.next == null,
          setNextCursorToNull: response.next == null,
        ),
      );
    } catch (e, st) {
      state = AsyncError<PaginationState<StoreModel>>(e, st)
          .copyWithPrevious(state);
    }
  }
}

final paginatedStoreFavoriteNotifier = AsyncNotifierProvider<
    PaginatedStoreFavoriteNotifier, PaginationState<StoreModel>>(
  () => PaginatedStoreFavoriteNotifier(),
);
