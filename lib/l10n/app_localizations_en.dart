import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get auth_loginTitle => 'Login';

  @override
  String get auth_signupTitle => 'Create Account';

  @override
  String get auth_verifyEmailTitle => 'Verify Email';

  @override
  String get auth_resetPasswordTitle => 'Reset Password';

  @override
  String get auth_forgotPasswordTitle => 'Forgot Password?';

  @override
  String get common_emailLabel => 'Email Address';

  @override
  String get common_emailHint => 'Enter your email';

  @override
  String get common_passwordLabel => 'Password';

  @override
  String get common_passwordHint => 'Enter your password';

  @override
  String get common_confirmPasswordLabel => 'Confirm Password';

  @override
  String get common_confirmPasswordHint => 'Enter your password again';

  @override
  String get common_fullNameLabel => 'Full Name';

  @override
  String get common_fullNameHint => 'Enter your full name';

  @override
  String get common_submitButton => 'Submit';

  @override
  String get common_or => 'OR';

  @override
  String get common_name => 'name';

  @override
  String get common_loading => 'Loading...';

  @override
  String get common_next => 'Next';

  @override
  String get login_title => 'Login';

  @override
  String get login_loginButton => 'Login';

  @override
  String get login_forgotPasswordLink => 'Forgot Password?';

  @override
  String get login_noAccountPrompt => 'Don\'t have an account?';

  @override
  String get login_signupLink => 'Sign Up';

  @override
  String get login_socialLoginPrompt => 'Sign in with';

  @override
  String get login_errorInvalidCredentials => 'Invalid email or password.';

  @override
  String get login_errorNetwork => 'Network error. Please try again.';

  @override
  String get login_errorUnknown => 'An unexpected error occurred. Please try again.';

  @override
  String get signup_title => 'Sign Up';

  @override
  String get signup_signupButton => 'Sign Up';

  @override
  String get signup_haveAccountPrompt => 'Already have an account?';

  @override
  String get signup_loginLink => 'Login';

  @override
  String get signup_socialSignupPrompt => 'Sign up with';

  @override
  String get signup_agreeTerms => 'By signing up, you agree to our Terms of Service and Privacy Policy.';

  @override
  String otp_instruction(Object email) {
    return 'Enter the 6-digit code sent to $email';
  }

  @override
  String get otp_textFieldLabel => 'OTP Code';

  @override
  String get otp_textFieldHint => 'Enter OTP';

  @override
  String get otp_verifyButton => 'Verify';

  @override
  String get otp_didNotReceiveCode => 'Didn\'t receive the code?';

  @override
  String get otp_resendCodeLink => 'Resend Code';

  @override
  String otp_resendCodeTimer(Object seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get otp_successMessage => 'Email verified successfully!';

  @override
  String get otp_errorMessageInvalidCode => 'Invalid or expired OTP code.';

  @override
  String get otp_errorMessageNetwork => 'Network error. Please try again.';

  @override
  String get otp_errorMessageUnknown => 'An unexpected error occurred during verification.';

  @override
  String get resetPassword_requestInstruction => 'Enter your email address to receive password reset instructions.';

  @override
  String get resetPassword_sendLinkButton => 'Send Reset Link';

  @override
  String get resetPassword_backToLoginLink => 'Back to Login';

  @override
  String resetPassword_requestSuccess(Object email) {
    return 'Password reset link sent to $email. Please check your inbox (and spam folder).';
  }

  @override
  String get resetPassword_errorEmailNotFound => 'No account found with this email address.';

  @override
  String get resetPassword_errorNetwork => 'Network error. Please try again.';

  @override
  String get resetPassword_errorUnknown => 'An unexpected error occurred. Please try again.';

  @override
  String get resetPassword_setNewPasswordTitle => 'Set New Password';

  @override
  String get resetPassword_newPasswordLabel => 'New Password';

  @override
  String get resetPassword_newPasswordHint => 'Enter your new password';

  @override
  String get resetPassword_confirmNewPasswordLabel => 'Confirm New Password';

  @override
  String get resetPassword_confirmNewPasswordHint => 'Enter your new password again';

  @override
  String get resetPassword_updatePasswordButton => 'Update Password';

  @override
  String get resetPassword_updateSuccess => 'Password updated successfully!';

  @override
  String get resetPassword_updateErrorInvalidToken => 'Invalid or expired reset token.';

  @override
  String get resetPassword_updateErrorPasswordMismatch => 'Passwords do not match.';

  @override
  String get resetPassword_updateErrorWeakPassword => 'New password is too weak.';

  @override
  String get social_divider => 'Or login using';

  @override
  String get social_signInWithGoogle => 'Sign in with Google';

  @override
  String get social_signInWithFacebook => 'Sign in with Facebook';

  @override
  String get social_signUpWithGoogle => 'Sign up with Google';

  @override
  String get social_signUpWithFacebook => 'Sign up with Facebook';

  @override
  String get social_errorCancelled => 'Social login cancelled.';

  @override
  String get social_errorNetwork => 'Network error during social login.';

  @override
  String get social_errorUnknown => 'An unknown error occurred during social login.';

  @override
  String get validation_required => 'This field is required.';

  @override
  String get validation_invalidEmail => 'Please enter a valid email address.';

  @override
  String validation_passwordTooShort(int minLength) {
    return 'Password must be at least $minLength characters long.';
  }

  @override
  String get validation_passwordsDoNotMatch => 'Passwords do not match.';
}
