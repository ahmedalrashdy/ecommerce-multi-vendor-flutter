import 'package:ecommerce/core/helpers/AppHelper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/handle_exception.dart';
import 'package:ecommerce/core/models/paginated_response.dart';
import '../../../core/consts/api_endpoints.dart';
import '../../../core/services/api/api_service.dart';
import '../models/user_address_model.dart';

class AddressRepo with ExceptionHandler {
  final APIService _apiService = AppHelper.apiService;

  Future<PaginatedResponse<UserAddressModel>> getUserAddresses(
      {String? url}) async {
    return await handleExceptionAsync2<PaginatedResponse<UserAddressModel>>(
        () async {
      final data = await _apiService.get(url ?? ApiEndpoint.userAddresses);
      return PaginatedResponse.fromJson(
          data, (json) => UserAddressModel.fromJson(json));
    });
  }

  Future<UserAddressModel> setDefaultAddress(int addressId) async {
    return await handleExceptionAsync2<UserAddressModel>(() async {
      final url = ApiEndpoint.setDefaultAddress(addressId);
      final data = await _apiService.post(url);
      return UserAddressModel.fromJson(data);
    });
  }

  Future<UserAddressModel> createAddress(Map<String, dynamic> data) async {
    return await handleExceptionAsync2<UserAddressModel>(() async {
      final responseData =
          await _apiService.post(ApiEndpoint.userAddresses, data: data);
      return UserAddressModel.fromJson(responseData);
    });
  }

  Future<UserAddressModel> updateAddress(
      int addressId, Map<String, dynamic> data) async {
    return await handleExceptionAsync2<UserAddressModel>(() async {
      final url = ApiEndpoint.addressDetail(addressId);
      final responseData = await _apiService.patch(url, data: data);
      return UserAddressModel.fromJson(responseData);
    });
  }

  Future<void> deleteAddress(int addressId) async {
    return await handleExceptionAsync2<void>(() async {
      final url = ApiEndpoint.addressDetail(addressId);
      await _apiService.delete(url);
    });
  }
}

final addressRepoProvider = Provider<AddressRepo>((ref) => AddressRepo());
