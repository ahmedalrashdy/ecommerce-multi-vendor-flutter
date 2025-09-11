import 'package:dio/dio.dart';
import 'package:ecommerce/core/helpers/AppHelper.dart';
import '../../helpers/app_exception.dart';
import 'bearer_interceptor_token.dart';

class APIService {
  final Dio _dio;

  APIService(String baseUrl) : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers["Accept"] = 'application/json';
    // _dio.options.connectTimeout = Duration(seconds: 20);
    // _dio.options.receiveTimeout = Duration(seconds: 20);
    // _dio.interceptors.add(RequestLoggingInterceptor());
  }

  void setAuthToken(String token) {
    _dio.interceptors
        .removeWhere((interceptor) => interceptor is BearerAuthInterceptor);
    _dio.interceptors.add(BearerAuthInterceptor(token));
  }

  void removeAuthToken() {
    _dio.interceptors
        .removeWhere((interceptor) => interceptor is BearerAuthInterceptor);
  }

  Dio get dioInstance => _dio;

  Future<dynamic> get(String path,
      {Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final response = await _dio.get(path,
          queryParameters: queryParameters, cancelToken: cancelToken);
      return response.data;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<dynamic> post(String path, {Object? data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<dynamic> put<T>(String path, {Object? data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response.data;
    } on DioException catch (e) {
      AppHelper.logger.e(e.toString());
      AppHelper.logger.e(e.type);
      AppHelper.logger.e(e.error);
      AppHelper.logger.e(e.stackTrace);
      throw AppException.fromDioError(e);
    }
  }

  Future<dynamic> delete(String path, {Object? data}) async {
    try {
      final response = await _dio.delete(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<dynamic> patch(String endpoint, dynamic data) async {
    try {
      final response = await _dio.patch(
        '$endpoint',
        data: data,
        options: Options(
          contentType: data is FormData
              ? Headers.multipartFormDataContentType
              : Headers.jsonContentType,
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<dynamic> postFormData(
    String path, {
    required FormData data,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        onSendProgress: onSendProgress,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );
      return response.data;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<dynamic> putFormData(
    String path, {
    required FormData data,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        onSendProgress: onSendProgress,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );
      return response.data;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}

class RequestLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String className = 'Unknown';
    String methodName = 'Unknown';

    AppHelper.logger.i(
        '[REQUEST] ${options.method} ${options.uri} | Class: $className | Method: $methodName');

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppHelper.logger.i(
        '[RESPONSE] ${response.requestOptions.method} ${response.requestOptions.uri} | Status: ${response.statusCode}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String className = 'Unknown';
    String methodName = 'Unknown';

    AppHelper.logger.e(
        '[ERROR] ${err.requestOptions.method} ${err.requestOptions.uri} | Class: $className | Method: $methodName | Error: ${err.message}');
    super.onError(err, handler);
  }
}
