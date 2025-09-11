import 'package:flutter/material.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';

class SocialLoginDivider extends StatelessWidget {
  final String text;

  const SocialLoginDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: context.colors.onSurface.withOpacity(0.2),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            text,
            style: TextStyle(
              color: context.colors.onSurface.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: context.colors.onSurface.withOpacity(0.2),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
