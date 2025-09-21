import 'package:ecommerce/core/helpers/AppHelper.dart';
import 'package:ecommerce/core/helpers/handle_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/consts/api_endpoints.dart';
import '../../../core/services/api/api_service.dart';
import '../../features/cart/models/cart_item_model.dart';
import '../../features/cart/models/grouped_cart_by_store_model.dart';
import '../models/paginated_response.dart';

class CartRepo with ExceptionHandler {
  final APIService _apiService = AppHelper.apiService;

  Future<PaginatedResponse<GroupedCartByStoreModel>> getCartItems(
      {String? url}) async {
    return await handleExceptionAsync2<
        PaginatedResponse<GroupedCartByStoreModel>>(() async {
      final data = await _apiService.get(url ?? ApiEndpoint.cartList);
      return PaginatedResponse.fromJson(
          data, (json) => GroupedCartByStoreModel.fromJson(json));
    });
  }

  Future<CartItemModel> addItemToCart({
    required int variantId,
    required int quantity,
  }) async {
    return await handleExceptionAsync2<CartItemModel>(() async {
      final body = {'variant_id': variantId, 'quantity': quantity};
      final data = await _apiService.post(ApiEndpoint.cartAddItem, data: body);
      return CartItemModel.fromJson(data);
    });
  }

  Future<CartItemModel> updateItemQuantity({
    required int cartItemId,
    required int newQuantity,
  }) async {
    return await handleExceptionAsync2<CartItemModel>(() async {
      final body = {'quantity': newQuantity};
      final url = ApiEndpoint.cartUpdateItem(cartItemId);
      final data = await _apiService.patch(url, data: body);
      return CartItemModel.fromJson(data);
    });
  }

  Future<void> deleteCartItem({required int cartItemId}) async {
    return await handleExceptionAsync2<void>(() async {
      final url = ApiEndpoint.cartDeleteItem(cartItemId);
      await _apiService.delete(url);
    });
  }
}

final cartRepoProvider = Provider<CartRepo>((ref) {
  return CartRepo();
});
