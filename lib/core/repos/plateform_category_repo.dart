import 'package:ecommerce/core/helpers/AppHelper.dart';
import 'package:ecommerce/core/helpers/handle_exception.dart';
import 'package:ecommerce/core/models/plateform_category_model.dart';
import '../consts/api_endpoints.dart';
import '../services/api/api_service.dart';

class PlatformCategoryRepo with ExceptionHandler {
  APIService apiService = AppHelper.apiService;
  PlatformCategoryRepo();

  Future<List<PlatformCategory>> getFeaturedCategories() async {
    return await handleExceptionAsync2<List<PlatformCategory>>(() async {
      List<dynamic> data =
          await apiService.get(ApiEndpoint.featuredPlatformCategories);
      return PlatformCategory.fromList(data);
    });
  }
}
