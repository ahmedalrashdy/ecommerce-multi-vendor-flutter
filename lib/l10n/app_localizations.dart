import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @auth_loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get auth_loginTitle;

  /// No description provided for @auth_signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get auth_signupTitle;

  /// No description provided for @auth_verifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get auth_verifyEmailTitle;

  /// No description provided for @auth_resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get auth_resetPasswordTitle;

  /// No description provided for @auth_forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get auth_forgotPasswordTitle;

  /// No description provided for @common_emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get common_emailLabel;

  /// No description provided for @common_emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get common_emailHint;

  /// No description provided for @common_passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get common_passwordLabel;

  /// No description provided for @common_passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get common_passwordHint;

  /// No description provided for @common_confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get common_confirmPasswordLabel;

  /// No description provided for @common_confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password again'**
  String get common_confirmPasswordHint;

  /// No description provided for @common_fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get common_fullNameLabel;

  /// No description provided for @common_fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get common_fullNameHint;

  /// No description provided for @common_submitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get common_submitButton;

  /// No description provided for @common_or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get common_or;

  /// No description provided for @common_name.
  ///
  /// In en, this message translates to:
  /// **'name'**
  String get common_name;

  /// No description provided for @common_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get common_loading;

  /// No description provided for @common_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get common_next;

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_title;

  /// No description provided for @login_loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_loginButton;

  /// No description provided for @login_forgotPasswordLink.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get login_forgotPasswordLink;

  /// No description provided for @login_noAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get login_noAccountPrompt;

  /// No description provided for @login_signupLink.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get login_signupLink;

  /// No description provided for @login_socialLoginPrompt.
  ///
  /// In en, this message translates to:
  /// **'Sign in with'**
  String get login_socialLoginPrompt;

  /// No description provided for @login_errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get login_errorInvalidCredentials;

  /// No description provided for @login_errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please try again.'**
  String get login_errorNetwork;

  /// No description provided for @login_errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get login_errorUnknown;

  /// No description provided for @signup_title.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup_title;

  /// No description provided for @signup_signupButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup_signupButton;

  /// No description provided for @signup_haveAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get signup_haveAccountPrompt;

  /// No description provided for @signup_loginLink.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get signup_loginLink;

  /// No description provided for @signup_socialSignupPrompt.
  ///
  /// In en, this message translates to:
  /// **'Sign up with'**
  String get signup_socialSignupPrompt;

  /// No description provided for @signup_agreeTerms.
  ///
  /// In en, this message translates to:
  /// **'By signing up, you agree to our Terms of Service and Privacy Policy.'**
  String get signup_agreeTerms;

  /// No description provided for @otp_instruction.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to {email}'**
  String otp_instruction(Object email);

  /// No description provided for @otp_textFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'OTP Code'**
  String get otp_textFieldLabel;

  /// No description provided for @otp_textFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get otp_textFieldHint;

  /// No description provided for @otp_verifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get otp_verifyButton;

  /// No description provided for @otp_didNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get otp_didNotReceiveCode;

  /// No description provided for @otp_resendCodeLink.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get otp_resendCodeLink;

  /// No description provided for @otp_resendCodeTimer.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String otp_resendCodeTimer(Object seconds);

  /// No description provided for @otp_successMessage.
  ///
  /// In en, this message translates to:
  /// **'Email verified successfully!'**
  String get otp_successMessage;

  /// No description provided for @otp_errorMessageInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired OTP code.'**
  String get otp_errorMessageInvalidCode;

  /// No description provided for @otp_errorMessageNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please try again.'**
  String get otp_errorMessageNetwork;

  /// No description provided for @otp_errorMessageUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred during verification.'**
  String get otp_errorMessageUnknown;

  /// No description provided for @resetPassword_requestInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address to receive password reset instructions.'**
  String get resetPassword_requestInstruction;

  /// No description provided for @resetPassword_sendLinkButton.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get resetPassword_sendLinkButton;

  /// No description provided for @resetPassword_backToLoginLink.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get resetPassword_backToLoginLink;

  /// No description provided for @resetPassword_requestSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to {email}. Please check your inbox (and spam folder).'**
  String resetPassword_requestSuccess(Object email);

  /// No description provided for @resetPassword_errorEmailNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email address.'**
  String get resetPassword_errorEmailNotFound;

  /// No description provided for @resetPassword_errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please try again.'**
  String get resetPassword_errorNetwork;

  /// No description provided for @resetPassword_errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get resetPassword_errorUnknown;

  /// No description provided for @resetPassword_setNewPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get resetPassword_setNewPasswordTitle;

  /// No description provided for @resetPassword_newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get resetPassword_newPasswordLabel;

  /// No description provided for @resetPassword_newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get resetPassword_newPasswordHint;

  /// No description provided for @resetPassword_confirmNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get resetPassword_confirmNewPasswordLabel;

  /// No description provided for @resetPassword_confirmNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password again'**
  String get resetPassword_confirmNewPasswordHint;

  /// No description provided for @resetPassword_updatePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get resetPassword_updatePasswordButton;

  /// No description provided for @resetPassword_updateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully!'**
  String get resetPassword_updateSuccess;

  /// No description provided for @resetPassword_updateErrorInvalidToken.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired reset token.'**
  String get resetPassword_updateErrorInvalidToken;

  /// No description provided for @resetPassword_updateErrorPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get resetPassword_updateErrorPasswordMismatch;

  /// No description provided for @resetPassword_updateErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'New password is too weak.'**
  String get resetPassword_updateErrorWeakPassword;

  /// No description provided for @social_divider.
  ///
  /// In en, this message translates to:
  /// **'Or login using'**
  String get social_divider;

  /// No description provided for @social_signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get social_signInWithGoogle;

  /// No description provided for @social_signInWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Facebook'**
  String get social_signInWithFacebook;

  /// No description provided for @social_signUpWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get social_signUpWithGoogle;

  /// No description provided for @social_signUpWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Facebook'**
  String get social_signUpWithFacebook;

  /// No description provided for @social_errorCancelled.
  ///
  /// In en, this message translates to:
  /// **'Social login cancelled.'**
  String get social_errorCancelled;

  /// No description provided for @social_errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error during social login.'**
  String get social_errorNetwork;

  /// No description provided for @social_errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred during social login.'**
  String get social_errorUnknown;

  /// No description provided for @validation_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get validation_required;

  /// No description provided for @validation_invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get validation_invalidEmail;

  /// Password length validation error message
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {minLength} characters long.'**
  String validation_passwordTooShort(int minLength);

  /// No description provided for @validation_passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get validation_passwordsDoNotMatch;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
