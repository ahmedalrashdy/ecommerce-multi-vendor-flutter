import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import '../../../core/consts/app_routes.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          Alignment.centerLeft, // محاذاة النص إلى اليسار (أو اليمين في العربية)
      child: TextButton(
        onPressed: () => context.push(AppRoutes.forgotPasswordScreen),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          // إزالة الـ splash effect لتحسين المظهر
          splashFactory: NoSplash.splashFactory,
        ),
        child: Text(
          "هل نسيت كلمة المرور؟", // نص عربي مباشر
          style: TextStyle(
            color: context.colors.primary, // استخدام اللون الأساسي مباشرة
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
