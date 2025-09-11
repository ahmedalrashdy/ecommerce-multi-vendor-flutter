// lib/features/auth/widgets/auth_prompt.dart (اسم مقترح جديد)

import 'package:flutter/material.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';

class AuthPrompt extends StatelessWidget {
  final String promptText;
  final String actionText;
  final VoidCallback onActionPressed;

  const AuthPrompt({
    super.key,
    required this.promptText,
    required this.actionText,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            promptText,
            style: TextStyle(
              color: context.colors.onSurface.withOpacity(0.8),
              fontSize: 15,
            ),
          ),
          TextButton(
            onPressed: onActionPressed,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              splashFactory: NoSplash.splashFactory,
            ),
            child: Text(
              actionText,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: context.colors.primary,
                // يمكن إضافة خط تحت النص إذا رغبت
                // decoration: TextDecoration.underline,
                // decorationColor: AppHelper.colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
