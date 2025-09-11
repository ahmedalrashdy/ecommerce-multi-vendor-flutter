import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/helpers/app_exception.dart';
import 'package:ecommerce/core/consts/api_endpoints.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/helpers/AppHelper.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit({String? initialResetToken})
      : super(ResetPasswordState(resetToken: initialResetToken));

  String _emailForRequest = "";

  Future<void> requestPasswordReset(String email) async {
    _emailForRequest = email;
    emit(state.copyWith(
        sendEmailStatus: AsyncStatus.loading, clearSendEmailError: true));

    try {
      await AppHelper.apiService
          .post(ApiEndpoint.resetPassword, data: {"email": email});
      print("ResetPasswordCubit: Request successful for email $email");
      emit(state.copyWith(sendEmailStatus: AsyncStatus.success));
    } on AppException catch (e) {
      print("ResetPasswordCubit: Request failed - ${e.drfErrors.allMessages}");
      emit(state.copyWith(
          sendEmailStatus: AsyncStatus.failure,
          sendEmailError: e.drfErrors.allMessages));
    }
  }

  String get emailForOtpScreen => _emailForRequest;

  void setResetToken(String token) {
    emit(state.copyWith(resetToken: token));
  }

  Future<void> confirmPasswordReset(String newPassword) async {
    if (state.resetToken == null || state.resetToken!.isEmpty) {
      print("ResetPasswordCubit: Cannot confirm reset, token is missing.");
      emit(state.copyWith(
          confirmResetStatus: AsyncStatus.failure,
          confirmResetError:
              "Reset token is missing. Please verify OTP again."));
      return;
    }

    emit(state.copyWith(
        confirmResetStatus: AsyncStatus.loading, clearConfirmResetError: true));

    try {
      await AppHelper.apiService.post(
        ApiEndpoint.confirmResetPassword,
        data: {"reset_token": state.resetToken!, "new_password": newPassword},
      );
      print("ResetPasswordCubit: Password reset confirmed successfully.");
      emit(state.copyWith(confirmResetStatus: AsyncStatus.success));
    } on AppException catch (e) {
      print(
          "ResetPasswordCubit: Confirm reset failed - ${e.drfErrors.allMessages}");
      emit(state.copyWith(
          confirmResetStatus: AsyncStatus.failure,
          confirmResetError: e.drfErrors.allMessages));
    }
  }
}
