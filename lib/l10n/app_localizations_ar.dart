import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get auth_loginTitle => 'تسجيل الدخول';

  @override
  String get auth_signupTitle => 'إنشاء حساب';

  @override
  String get auth_verifyEmailTitle => 'التحقق من البريد الإلكتروني';

  @override
  String get auth_resetPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get auth_forgotPasswordTitle => 'هل نسيت كلمة المرور؟';

  @override
  String get common_emailLabel => 'البريد الإلكتروني';

  @override
  String get common_emailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get common_passwordLabel => 'كلمة المرور';

  @override
  String get common_passwordHint => 'أدخل كلمة المرور';

  @override
  String get common_confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get common_confirmPasswordHint => 'أدخل كلمة المرور مرة أخرى';

  @override
  String get common_fullNameLabel => 'الاسم الكامل';

  @override
  String get common_fullNameHint => 'أدخل اسمك الكامل';

  @override
  String get common_submitButton => 'إرسال';

  @override
  String get common_or => 'أو';

  @override
  String get common_name => 'الاسم';

  @override
  String get common_loading => 'جاري التحميل...';

  @override
  String get common_next => 'التالي';

  @override
  String get login_title => 'تسجيل الدخول';

  @override
  String get login_loginButton => 'تسجيل الدخول';

  @override
  String get login_forgotPasswordLink => 'هل نسيت كلمة المرور؟';

  @override
  String get login_noAccountPrompt => 'ليس لديك حساب؟';

  @override
  String get login_signupLink => 'إنشاء حساب';

  @override
  String get login_socialLoginPrompt => 'تسجيل الدخول باستخدام';

  @override
  String get login_errorInvalidCredentials => 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get login_errorNetwork => 'خطأ في الشبكة. يرجى المحاولة مرة أخرى.';

  @override
  String get login_errorUnknown => 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';

  @override
  String get signup_title => 'إنشاء حساب';

  @override
  String get signup_signupButton => 'إنشاء حساب';

  @override
  String get signup_haveAccountPrompt => 'هل لديك حساب بالفعل؟';

  @override
  String get signup_loginLink => 'تسجيل الدخول';

  @override
  String get signup_socialSignupPrompt => 'إنشاء حساب باستخدام';

  @override
  String get signup_agreeTerms => 'بالتسجيل، فإنك توافق على شروط الخدمة وسياسة الخصوصية الخاصة بنا.';

  @override
  String otp_instruction(Object email) {
    return 'أدخل الرمز المكون من 6 أرقام المرسل إلى $email';
  }

  @override
  String get otp_textFieldLabel => 'رمز OTP';

  @override
  String get otp_textFieldHint => 'أدخل رمز OTP';

  @override
  String get otp_verifyButton => 'تحقق';

  @override
  String get otp_didNotReceiveCode => 'لم تستلم الرمز؟';

  @override
  String get otp_resendCodeLink => 'إعادة إرسال الرمز';

  @override
  String otp_resendCodeTimer(Object seconds) {
    return 'إعادة إرسال الرمز خلال $seconds ثانية';
  }

  @override
  String get otp_successMessage => 'تم التحقق من البريد الإلكتروني بنجاح!';

  @override
  String get otp_errorMessageInvalidCode => 'رمز OTP غير صالح أو منتهي الصلاحية.';

  @override
  String get otp_errorMessageNetwork => 'خطأ في الشبكة. يرجى المحاولة مرة أخرى.';

  @override
  String get otp_errorMessageUnknown => 'حدث خطأ غير متوقع أثناء التحقق.';

  @override
  String get resetPassword_requestInstruction => 'أدخل عنوان بريدك الإلكتروني لتلقي تعليمات إعادة تعيين كلمة المرور.';

  @override
  String get resetPassword_sendLinkButton => 'إرسال رابط إعادة التعيين';

  @override
  String get resetPassword_backToLoginLink => 'العودة إلى تسجيل الدخول';

  @override
  String resetPassword_requestSuccess(Object email) {
    return 'تم إرسال رابط إعادة تعيين كلمة المرور إلى $email. يرجى التحقق من صندوق الوارد (والمجلدات غير المرغوب فيها).';
  }

  @override
  String get resetPassword_errorEmailNotFound => 'لم يتم العثور على حساب بعنوان البريد الإلكتروني هذا.';

  @override
  String get resetPassword_errorNetwork => 'خطأ في الشبكة. يرجى المحاولة مرة أخرى.';

  @override
  String get resetPassword_errorUnknown => 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';

  @override
  String get resetPassword_setNewPasswordTitle => 'تعيين كلمة مرور جديدة';

  @override
  String get resetPassword_newPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get resetPassword_newPasswordHint => 'أدخل كلمة المرور الجديدة';

  @override
  String get resetPassword_confirmNewPasswordLabel => 'تأكيد كلمة المرور الجديدة';

  @override
  String get resetPassword_confirmNewPasswordHint => 'أدخل كلمة المرور الجديدة مرة أخرى';

  @override
  String get resetPassword_updatePasswordButton => 'تحديث كلمة المرور';

  @override
  String get resetPassword_updateSuccess => 'تم تحديث كلمة المرور بنجاح!';

  @override
  String get resetPassword_updateErrorInvalidToken => 'رمز إعادة التعيين غير صالح أو منتهي الصلاحية.';

  @override
  String get resetPassword_updateErrorPasswordMismatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get resetPassword_updateErrorWeakPassword => 'كلمة المرور الجديدة ضعيفة جدًا.';

  @override
  String get social_divider => 'أو سجل دخولك عبر';

  @override
  String get social_signInWithGoogle => 'تسجيل الدخول باستخدام Google';

  @override
  String get social_signInWithFacebook => 'تسجيل الدخول باستخدام Facebook';

  @override
  String get social_signUpWithGoogle => 'إنشاء حساب باستخدام Google';

  @override
  String get social_signUpWithFacebook => 'إنشاء حساب باستخدام Facebook';

  @override
  String get social_errorCancelled => 'تم إلغاء تسجيل الدخول الاجتماعي.';

  @override
  String get social_errorNetwork => 'خطأ في الشبكة أثناء تسجيل الدخول الاجتماعي.';

  @override
  String get social_errorUnknown => 'حدث خطأ غير معروف أثناء تسجيل الدخول الاجتماعي.';

  @override
  String get validation_required => 'هذا الحقل مطلوب.';

  @override
  String get validation_invalidEmail => 'الرجاء إدخال عنوان بريد إلكتروني صالح.';

  @override
  String validation_passwordTooShort(int minLength) {
    return 'يجب أن تتكون كلمة المرور من $minLength أحرف على الأقل.';
  }

  @override
  String get validation_passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين.';
}
