import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/core/enums/enums.dart';
import 'package:ecommerce/core/helpers/AppHelper.dart';
import 'package:ecommerce/core/helpers/app_exception.dart';
import 'package:ecommerce/core/helpers/app_message.dart';
import 'package:ecommerce/core/services/api/api_service.dart';

import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  APIService apiService = AppHelper.apiService;
  String? oldPassword;
  ChangePasswordCubit() : super(ChangePasswordState());

  Future<void> changePassword(String newPassword) async {
    emit(ChangePasswordState(status: AsyncStatus.loading));
    try {
      await apiService.post("/auth/change-password/", data: {
        "new_password": newPassword,
        "old_password": oldPassword,
      });
      emit(ChangePasswordState(status: AsyncStatus.success));
      AppMessage.showSuccess(message: "تم تغيير كلمة المرور بنجاح");
    } on AppException catch (e) {
      emit(ChangePasswordState(status: AsyncStatus.failure));
      if (e.drfErrors.errors['new_password'] != null) {
        AppMessage.showError(
            message: e.drfErrors.errors["new_password"]!.first);
      }
    }
  }

  Future<void> checkPassword(String password) async {
    emit(ChangePasswordState(status: AsyncStatus.loading));
    try {
      await apiService
          .post("/auth/check-password/", data: {"password": password});
      emit(ChangePasswordState(status: AsyncStatus.success));
      oldPassword = password;
    } on AppException catch (e) {
      emit(ChangePasswordState(status: AsyncStatus.failure));
      AppMessage.showError(message: e.drfErrors.allMessages);
    }
  }
}
