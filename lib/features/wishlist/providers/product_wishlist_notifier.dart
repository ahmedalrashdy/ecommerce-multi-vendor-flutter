import 'dart:async';
import 'package:ecommerce/core/helpers/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repos/wishlist_repo.dart';

class WishlistNotifier extends StateNotifier<AsyncValue<Set<int>>> {
  final Ref _ref;

  WishlistNotifier(this._ref) : super(const AsyncValue.loading()) {
    _fetchInitialWishlist();
  }

  WishlistRepository get _repository => _ref.read(wishlistRepoProvider);

  Future<void> _fetchInitialWishlist() async {
    try {
      final result = await _repository.fetchFavoriteProductIds();
      state = AsyncValue.data(result);
    } on AppException catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addProduct(int productId) async {
    state.whenData((ids) {
      state = AsyncValue.data({...ids, productId});
    });
    try {
      await _repository.addProductToWishlist(productId);
    } on AppException catch (e) {
      state.whenData((ids) {
        state = AsyncValue.data(ids..remove(productId));
      });
    }
  }

  // إزالة منتج
  Future<void> removeProduct(int productId) async {
    state.whenData((ids) {
      state = AsyncValue.data(ids..remove(productId));
    });
    try {
      await _repository.removeProductFromWishlist(productId);
    } on AppException catch (e) {
      state.whenData((ids) {
        state = AsyncValue.data({...ids, productId});
      });
    }
  }

  Future<void> toggleFavorite(int productId) async {
    final isFavorite = state.valueOrNull?.contains(productId) ?? false;
    if (isFavorite) {
      await removeProduct(productId);
    } else {
      await addProduct(productId);
    }
  }
}

final productWishlistNotifierProvider =
    StateNotifierProvider<WishlistNotifier, AsyncValue<Set<int>>>((ref) {
  return WishlistNotifier(ref);
});

final isFavoriteProvider = Provider.family<bool, int>((ref, productId) {
  final favoriteIds = ref.watch(productWishlistNotifierProvider);
  return favoriteIds.valueOrNull?.contains(productId) ?? false;
});
