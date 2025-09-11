import 'package:dio/dio.dart';
import '../enums/enums.dart';
import '../services/api/dfr_errors.dart';

class AppException implements Exception {
  final AppExceptionType type;
  final int? statusCode;
  final DrfErrors drfErrors;

  AppException({
    required this.type,
    this.statusCode,
    required this.drfErrors,
  });

  static DrfErrors getDrfErrors(dynamic responseData, AppExceptionType type) {
    DrfErrors finalDrfErrors;
    if (responseData != null) {
      try {
        finalDrfErrors = DrfErrors.fromJson(responseData);
      } catch (e) {
        finalDrfErrors = DrfErrors.fromJson(
            {"detail": "Failed to parse server error response."});
      }
    } else {
      String message;
      switch (type) {
        case AppExceptionType.network:
          message = "Network error. Please check your internet connection.";
          break;
        case AppExceptionType.cancel:
          message = "Request was cancelled.";
          break;
        default:
          message = "An unknown error occurred without a server response.";
          break;
      }
      finalDrfErrors = DrfErrors.fromJson({
        "detail": [message]
      });
    }
    return finalDrfErrors;
  }

  factory AppException.fromDioError(DioException dioError) {
    AppExceptionType type = getType(dioError);
    final responseData = dioError.response?.data;
    return AppException(
      type: type,
      statusCode: dioError.response?.statusCode,
      drfErrors: getDrfErrors(responseData, type),
    );
  }

  factory AppException.fromData(dynamic data, AppExceptionType type,
      {int? statusCode}) {
    return AppException(
      type: type,
      statusCode: statusCode,
      drfErrors: getDrfErrors(data, type),
    );
  }

  static AppExceptionType getType(DioException dioError) {
    AppExceptionType type;
    switch (dioError.type) {
      case DioExceptionType.badResponse:
        switch (dioError.response?.statusCode) {
          case 400:
            type = AppExceptionType.validation;
            break;
          case 401:
          case 403:
            type = AppExceptionType.auth;
            break;
          case 404:
            type = AppExceptionType.notFound;
            break;
          case 500:
          case 502:
          case 503:
            type = AppExceptionType.server;
            break;
          default:
            type = AppExceptionType.badResponse;
            break;
        }
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        type = AppExceptionType.network;
        break;
      case DioExceptionType.cancel:
        type = AppExceptionType.cancel;
        break;
      default:
        type = AppExceptionType.unknown;
        break;
    }
    return type;
  }

  @override
  String toString() {
    return 'ApiException (Type: ${type.name}, StatusCode: $statusCode)\nMessage: ${drfErrors.allMessages}';
  }
}
