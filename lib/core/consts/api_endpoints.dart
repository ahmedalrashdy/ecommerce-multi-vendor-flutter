import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ApiEndpoint {
  static String APIBaseURL = "${dotenv.env['IP']}/api/v1/";
  //Auth
  static const String login = "auth/login/";
  static const String register = "auth/register/";
  static const String verifyEmail = "auth/verify-email/";
  static const String verifyResetPasswordOTP =
      "auth/verify-reset-password-otp/";
  static const String resendOTP = "auth/resend-otp/";
  static const String resetPassword = "auth/reset-password/";
  static const String changePassword = "auth/change-password/";
  static const String logout = "auth/logout/";
  static const String confirmResetPassword = "auth/confirm-reset-password/";
}
