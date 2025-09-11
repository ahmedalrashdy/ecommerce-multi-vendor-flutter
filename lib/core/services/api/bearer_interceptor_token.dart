import 'package:dio/dio.dart';

class BearerAuthInterceptor extends Interceptor {
  final String _token;

  BearerAuthInterceptor(this._token);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $_token';
    super.onRequest(options, handler);
  }
}
