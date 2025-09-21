import 'package:ecommerce/core/enums/enums.dart';
import 'package:ecommerce/core/helpers/app_exception.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

mixin ExceptionHandler {
  final Logger logger = Get.find();

  Future<T> handleExceptionAsync2<T>(
    Future<T> Function() action,
  ) async {
    try {
      return await action();
    } on AppException catch (e, stackTrace) {
      rethrow;
    } catch (e, stackTrace) {
      final className = runtimeType.toString();
      logger.e(
        "class:[$className] ,Unhandled Exception:[$e]",
        error: e,
        stackTrace: stackTrace,
      );

      throw AppException.fromData({
        "detail": "حدث خطأ غير معروف",
      }, AppExceptionType.unknown);
    }
  }
}
