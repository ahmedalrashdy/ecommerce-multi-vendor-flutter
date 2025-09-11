// lib/widgets/custom_form_text_field.dart

import 'package:flutter/material.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';

class CustomFormTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String label;
  final IconData? icon;
  final bool hasPasswordToggle;
  final VoidCallback? onTogglePassword;
  final String? Function(String?)? validator;
  final bool obscureText;
  final String? errorMessage;
  final ValueChanged<String>? onChanged;

  const CustomFormTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.icon,
    this.hasPasswordToggle = false,
    this.onTogglePassword,
    this.validator,
    this.obscureText = false,
    this.errorMessage,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد لون الحدود والأيقونة بناءً على وجود خطأ
    final bool hasError = errorMessage != null && errorMessage!.isNotEmpty;
    final Color activeColor =
        hasError ? context.colors.error : context.colors.primary;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      // نمط النص الذي يكتبه المستخدم
      style: TextStyle(
        fontSize: 16,
        color: context.colors.onSurface,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        // نمط النص للتسمية (Label)
        labelStyle: TextStyle(
          fontSize: 16,
          color: context.colors.onSurface.withOpacity(0.7),
        ),
        // نمط النص للخطأ
        errorText: errorMessage,
        errorStyle: TextStyle(
          fontSize: 12,
          color: context.colors.error,
          fontWeight: FontWeight.w500,
        ),
        // الأيقونة الأمامية
        prefixIcon: icon != null
            ? Icon(
                icon,
                color: activeColor.withOpacity(0.7),
                size: 22,
              )
            : null,
        // أيقونة تبديل رؤية كلمة المرور
        suffixIcon: hasPasswordToggle
            ? IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: context.colors.onSurface.withOpacity(0.6),
                  size: 22,
                ),
                onPressed: onTogglePassword,
              )
            : null,

        // إعدادات الحدود
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        filled: true,
        fillColor: context.colors.surface, // لون خلفية الحقل
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.colors.onSurface.withOpacity(0.2), // لون الحد العادي
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.colors.onSurface.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.colors.primary, // لون الحد عند التركيز
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.colors.error, // لون الحد عند وجود خطأ
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.colors.error,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
