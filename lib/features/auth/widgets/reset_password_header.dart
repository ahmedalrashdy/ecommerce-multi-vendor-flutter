// lib/features/auth/widgets/reset_password_header.dart

import 'package:flutter/material.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';

class ResetPasswordHeader extends StatelessWidget {
  final String title;
  final String subTitle;

  const ResetPasswordHeader(
      {super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colors.surface, // استخدام لون السطح
            boxShadow: [
              BoxShadow(
                color: context.colors.primary.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            Icons.lock_reset_rounded,
            size: 64,
            color: context.colors.primary, // استخدام اللون الأساسي للأيقونة
          ),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: TextStyle(
            fontSize: 26, // حجم خط مناسب للعنوان
            fontWeight: FontWeight.bold,
            color: context.colors.onSurface, // لون النص الأساسي
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          subTitle,
          style: TextStyle(
            fontSize: 16,
            color: context.colors.onSurface.withOpacity(0.7), // لون أفتح للوصف
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
