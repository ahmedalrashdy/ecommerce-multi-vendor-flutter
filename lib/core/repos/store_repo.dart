import 'package:ecommerce/core/helpers/AppHelper.dart';
import 'package:ecommerce/core/helpers/handle_exception.dart';
import 'package:ecommerce/core/models/paginated_response.dart';
import 'package:ecommerce/core/models/store_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../consts/api_endpoints.dart';
import '../models/store_detail_model.dart';
import '../services/api/api_service.dart';

class StoreRepo with ExceptionHandler {
  APIService apiService = AppHelper.apiService;
  StoreRepo();

  Future<PaginatedResponse<StoreModel>> getStores(
      {String? url, Map<String, String>? params}) async {
    return await handleExceptionAsync2<PaginatedResponse<StoreModel>>(() async {
      dynamic data = await apiService.get(
        url ?? ApiEndpoint.stores,
        queryParameters: params,
      );
      return PaginatedResponse<StoreModel>.fromJson(
        data,
        (json) => StoreModel.fromJson(json),
      );
    });
  }

  Future<StoreDetailModel> getStoreDetails(int storeId) async {
    return await handleExceptionAsync2<StoreDetailModel>(() async {
      final url = ApiEndpoint.storeDetail(storeId);
      final data = await apiService.get(url);
      return StoreDetailModel.fromJson(data);
    });
  }
}

final storeRepoProvider = Provider<StoreRepo>((ref) {
  return StoreRepo();
});
