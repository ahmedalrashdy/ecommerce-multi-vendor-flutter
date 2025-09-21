import 'package:ecommerce/core/consts/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../consts/api_endpoints.dart';
import '../helpers/AppHelper.dart';
import '../helpers/handle_exception.dart';
import '../models/paginated_response.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';
import '../services/api/api_service.dart';

class SearchRepo with ExceptionHandler {
  final APIService _apiService = AppHelper.apiService;

  SearchRepo();

  Future<PaginatedResponse<ProductModel>> searchProducts({
    Map<String, String>? params,
    String? url,
  }) async {
    return await handleExceptionAsync2<PaginatedResponse<ProductModel>>(
        () async {
      dynamic data = await _apiService.get(url ?? ApiEndpoint.productSearch,
          queryParameters: params);

      return PaginatedResponse<ProductModel>.fromJson(
        data,
        (json) => ProductModel.fromJson(json),
      );
    });
  }

  Future<PaginatedResponse<StoreModel>> searchStores({
    Map<String, String>? params,
    String? url,
  }) async {
    return await handleExceptionAsync2<PaginatedResponse<StoreModel>>(() async {
      dynamic data = await _apiService.get(url ?? ApiEndpoint.storeSearch,
          queryParameters: params);

      return PaginatedResponse<StoreModel>.fromJson(
        data,
        (json) => StoreModel.fromJson(json),
      );
    });
  }
}

// Provider for the SearchRepo
final searchRepoProvider = Provider<SearchRepo>((ref) {
  return SearchRepo();
});
