import 'package:ecommerce/core/helpers/AppHelper.dart';
import 'package:ecommerce/core/helpers/handle_exception.dart';
import 'package:ecommerce/core/models/paginated_response.dart';
import 'package:ecommerce/features/products/models/product_detail_model.dart';
import '../consts/api_endpoints.dart';
import '../models/product_category_model.dart';
import '../models/product_model.dart';
import '../services/api/api_service.dart';

class ProductRepository with ExceptionHandler {
  APIService apiService = AppHelper.apiService;
  ProductRepository();

  Future<PaginatedResponse<ProductModel>> getFeaturedProducts(
      {String? url, Map<String, String>? params}) async {
    return await handleExceptionAsync2<PaginatedResponse<ProductModel>>(
        () async {
      dynamic data = await apiService.get(url ?? ApiEndpoint.featuredProducts,
          queryParameters: params);
      return PaginatedResponse.fromJson(
        data,
        (json) => ProductModel.fromJson(json),
      );
    });
  }

  Future<PaginatedResponse<ProductModel>> getFavoriteProducts(
      {String? url, Map<String, String>? params}) async {
    return await handleExceptionAsync2<PaginatedResponse<ProductModel>>(
        () async {
      dynamic data = await apiService.get(url ?? ApiEndpoint.productWishLists,
          queryParameters: params);
      return PaginatedResponse.fromJson(
        data,
        (json) => ProductModel.fromJson(json),
      );
    });
  }

  Future<ProductDetailModel> getProductDetails(int productId) async {
    return await handleExceptionAsync2<ProductDetailModel>(() async {
      Map<String, dynamic> data =
          await apiService.get(ApiEndpoint.productDetails(productId));
      return ProductDetailModel.fromJson(data);
    });
  }

  Future<List<ProductCategoryModel>> getStoreProductCategories(
      int storeId) async {
    return await handleExceptionAsync2<List<ProductCategoryModel>>(() async {
      final url = ApiEndpoint.storeProductCategories(storeId);
      final data = await apiService.get(url);
      return ProductCategoryModel.fromList(data);
    });
  }

  Future<PaginatedResponse<ProductModel>> getStoreProducts({
    String? url,
    required int storeId,
    int? categoryId,
  }) async {
    return await handleExceptionAsync2<PaginatedResponse<ProductModel>>(
        () async {
      final Map<String, dynamic> params = {};
      if (categoryId != null) {
        params['category_id'] = categoryId.toString();
      }

      final endpointUrl = url ?? ApiEndpoint.storeProducts(storeId);
      final data = await apiService.get(endpointUrl, queryParameters: params);
      return PaginatedResponse.fromJson(
          data, (json) => ProductModel.fromJson(json));
    });
  }
}
