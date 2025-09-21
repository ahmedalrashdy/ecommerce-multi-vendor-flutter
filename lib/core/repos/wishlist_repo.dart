import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../consts/api_endpoints.dart';
import '../helpers/AppHelper.dart';
import '../helpers/handle_exception.dart';
import '../models/paginated_response.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';
import '../services/api/api_service.dart';

class WishlistRepository with ExceptionHandler {
  final APIService _apiService = AppHelper.apiService;

  // ----------------- Products -----------------

  Future<void> addProductToWishlist(int productId) async {
    return await handleExceptionAsync2<void>(() async {
      await _apiService.post(
        ApiEndpoint.addProductToWishlist,
        data: {'product': productId},
      );
      return;
    });
  }

  Future<void> removeProductFromWishlist(int productId) async {
    return await handleExceptionAsync2<void>(() async {
      await _apiService.delete(
        ApiEndpoint.removeProductFromWishlist(productId),
      );
      return;
    });
  }

  Future<Set<int>> fetchFavoriteProductIds() async {
    return await handleExceptionAsync2<Set<int>>(() async {
      final response = await _apiService.get(ApiEndpoint.wishlistProductIds);
      return (response).cast<int>().toSet();
    });
  }

  Future<PaginatedResponse<ProductModel>> getFavoriteProducts(
      {String? url}) async {
    return await handleExceptionAsync2<PaginatedResponse<ProductModel>>(
        () async {
      final response =
          await _apiService.get(url ?? ApiEndpoint.productWishLists);

      final paginatedData = PaginatedResponse.fromJson(
        response,
        (json) => ProductModel.fromJson(json),
      );

      return paginatedData;
    });
  }

  // ----------------- Stores -----------------

  Future<void> addStoreToWishlist(int storeId) async {
    return await handleExceptionAsync2<void>(() async {
      await _apiService.post(
        ApiEndpoint.addStoreToWishlist,
        data: {'store': storeId},
      );
      return;
    });
  }

  Future<void> removeStoreFromWishlist(int storeId) async {
    return await handleExceptionAsync2<void>(() async {
      await _apiService.delete(
        ApiEndpoint.removeStoreFromWishlist(storeId),
      );
      return;
    });
  }

  Future<Set<int>> fetchFavoriteStoreIds() async {
    return await handleExceptionAsync2<Set<int>>(() async {
      final response = await _apiService.get(ApiEndpoint.wishlistStoreIds);
      return (response).cast<int>().toSet();
    });
  }

  Future<PaginatedResponse<StoreModel>> getFavoriteStores(
      {String? url, Map<String, String>? params}) async {
    return await handleExceptionAsync2<PaginatedResponse<StoreModel>>(() async {
      dynamic data = await _apiService.get(url ?? ApiEndpoint.storeWishLists,
          queryParameters: params);
      return PaginatedResponse<StoreModel>.fromJson(
        data,
        (json) => StoreModel.fromJson(json),
      );
    });
  }
}

final wishlistRepoProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepository();
});
