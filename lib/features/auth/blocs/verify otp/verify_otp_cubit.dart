import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/consts/simple_cache_keys.dart';
import 'package:ecommerce/core/helpers/app_exception.dart';
import 'package:ecommerce/core/consts/api_endpoints.dart';
import 'package:ecommerce/core/blocs/auth/auth_bloc.dart';
import 'package:ecommerce/core/blocs/auth/auth_events.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/helpers/AppHelper.dart';
import '../../../../core/models/auth_model.dart';
import 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final AuthBloc _authBloc;
  final String email;
  final bool isResetPassword;

  VerifyOtpCubit({
    required AuthBloc authBloc,
    required this.email,
    required this.isResetPassword,
  })  : _authBloc = authBloc,
        super(const VerifyOtpState());

  Future<void> verifyOtp(String otp) async {
    emit(state.copyWith(verifyStatus: AsyncStatus.loading, clearAll: true));

    try {
      if (isResetPassword) {
        final data = await AppHelper.apiService.post(
          ApiEndpoint.verifyResetPasswordOTP,
          data: {"email": email, "otp": otp},
        );

        emit(state.copyWith(
          verifyStatus: AsyncStatus.success,
          resetToken: data['reset_token'],
        ));
      } else {
        // --- منطق التحقق من التسجيل ---
        final emailFromCache =
            AppHelper.sharedPref.getString(SimpleCacheKeys.registerEmail);
        final data = await AppHelper.apiService.post(
          ApiEndpoint.verifyEmail,
          data: {"email": emailFromCache, "otp": otp},
        );
        print("VerifyOtpCubit (Register): Verification successful.");
        final authModel = AuthModel.fromMap(data);
        _authBloc.add(AuthLoggedIn(authModel: authModel));
        await AppHelper.sharedPref.remove(SimpleCacheKeys.registerEmail);
        // The UI should listen to AuthBloc to navigate. No need to emit success here.
      }
    } on AppException catch (e) {
      print("VerifyOtpCubit: Verification failed - ${e.drfErrors.allMessages}");
      emit(state.copyWith(
          verifyStatus: AsyncStatus.failure,
          verifyError: e.drfErrors.allMessages));
    }
  }

  Future<void> resendOtp() async {
    emit(state.copyWith(
        resendStatus: AsyncStatus.loading,
        clearResendError: true,
        cooldownSeconds: 0));

    try {
      await AppHelper.apiService
          .post(ApiEndpoint.resendOTP, data: {"email": email});
      print("VerifyOtpCubit: Resend successful for email $email");
      emit(state.copyWith(resendStatus: AsyncStatus.success));
    } on AppException catch (e) {
      print("VerifyOtpCubit: Resend failed - ${e.drfErrors.allMessages}");
      // You can add special logic here for too many requests if needed
      // e.g. parsing `waiting_seconds` from e.drfErrors
      emit(state.copyWith(
          resendStatus: AsyncStatus.failure,
          resendError: e.drfErrors.allMessages));
    }
  }

  Future<void> clearRegistrationCache() async {
    if (!isResetPassword) {
      try {
        await AppHelper.sharedPref.remove(SimpleCacheKeys.registerEmail);
        print("VerifyOtpCubit: Cleared temp email cache on back/cancel.");
      } catch (e) {
        print(
            "VerifyOtpCubit: Failed to clear temp email cache - ${e.toString()}");
      }
    }
  }
}
