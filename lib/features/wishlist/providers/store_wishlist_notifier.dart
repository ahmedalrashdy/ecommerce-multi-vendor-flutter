import 'dart:async';
import 'package:ecommerce/core/helpers/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repos/wishlist_repo.dart';

class StoreWishlistNotifier extends StateNotifier<AsyncValue<Set<int>>> {
  final Ref _ref;

  StoreWishlistNotifier(this._ref) : super(const AsyncValue.loading()) {
    _fetchInitialStoreWishlist();
  }

  WishlistRepository get _repository => _ref.read(wishlistRepoProvider);

  Future<void> _fetchInitialStoreWishlist() async {
    try {
      final result = await _repository.fetchFavoriteStoreIds();
      state = AsyncValue.data(result);
    } on AppException catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addStore(int storeId) async {
    state.whenData((ids) {
      state = AsyncValue.data({...ids, storeId});
    });
    try {
      await _repository.addStoreToWishlist(storeId);
    } on AppException catch (e) {
      state.whenData((ids) {
        state = AsyncValue.data(ids..remove(storeId));
      });
    }
  }

  Future<void> removeStore(int storeId) async {
    state.whenData((ids) {
      state = AsyncValue.data(ids..remove(storeId));
    });
    try {
      await _repository.removeStoreFromWishlist(storeId);
    } on AppException catch (e) {
      state.whenData((ids) {
        state = AsyncValue.data({...ids, storeId});
      });
    }
  }

  Future<void> toggleFavorite(int storeId) async {
    final isFavorite = state.valueOrNull?.contains(storeId) ?? false;
    if (isFavorite) {
      await removeStore(storeId);
    } else {
      await addStore(storeId);
    }
  }
}

final storeWishlistNotifierProvider =
    StateNotifierProvider<StoreWishlistNotifier, AsyncValue<Set<int>>>((ref) {
  return StoreWishlistNotifier(ref);
});

final isStoreFavoriteProvider = Provider.family<bool, int>((ref, storeId) {
  final favoriteIds = ref.watch(storeWishlistNotifierProvider);
  return favoriteIds.valueOrNull?.contains(storeId) ?? false;
});
