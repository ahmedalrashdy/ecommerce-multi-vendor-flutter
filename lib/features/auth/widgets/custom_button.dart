// lib/widgets/custom_button.dart (أو أي مسار عام للودجتات)

import 'package:flutter/material.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isLoading;
  final String title;

  const CustomButton({
    super.key,
    this.onPressed,
    required this.title,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد لون النص ومؤشر التحميل بناءً على حالة الزر
    final Color contentColor = (isLoading || onPressed == null)
        ? context.colors.onSurface
        : context.colors.onPrimary;

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 2,
          // استخدام AppHelper للون خلفية الزر
          backgroundColor: context.colors.primary,
          // تعطيل لون الزر عند عدم تفعيله
          disabledBackgroundColor: context.colors.primary.withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(contentColor),
                ),
              ),
            if (isLoading) const SizedBox(width: 10),
            Text(
              title,
              // تطبيق النمط مباشرة
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: contentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
