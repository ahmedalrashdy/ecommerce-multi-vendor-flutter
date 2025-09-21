import 'package:ecommerce/core/providers/providers.dart';
import 'package:ecommerce/core/repos/store_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/store_model.dart';
import '../../../core/providers/paginated_state.dart';

class PaginationStoresProvider
    extends AutoDisposeFamilyAsyncNotifier<PaginationState<StoreModel>, int?> {
  @override
  Future<PaginationState<StoreModel>> build(int? categoryId) async {
    final storeByProvider = ref.read(storeSortByProvider("stores-list-screen"));
    final repository = ref.read(storeRepoProvider);
    final response = await repository.getStores(params: {
      if (categoryId != null) "platform_category": categoryId.toString(),
      "sort-by": storeByProvider.searchValue,
    });

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

    final repository = ref.read(storeRepoProvider);

    try {
      final response = await repository.getStores(url: currentState.nextCursor);
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

final paginatedStoresNotifier = AsyncNotifierProvider.autoDispose
    .family<PaginationStoresProvider, PaginationState<StoreModel>, int?>(
  () => PaginationStoresProvider(),
);
