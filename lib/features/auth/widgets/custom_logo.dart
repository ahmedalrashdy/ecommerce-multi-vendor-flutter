// lib/widgets/custom_logo.dart

import 'package:flutter/material.dart';
import 'package:ecommerce/core/consts/app_assets.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';

// تأكد من المسار

class CustomLogo extends StatelessWidget {
  const CustomLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'logo', // يمكنك إبقاء الـ tag كما هو
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.colors.surface, // استخدام لون السطح من الثيم
          boxShadow: [
            BoxShadow(
              color: context.colors.primary
                  .withOpacity(0.15), // استخدام لون الظل من AppHelper
              spreadRadius: 5,
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Image.asset(
          AppAssets.imagesLogo, // تأكد أن هذا المسار صحيح
          height: 100,
        ),
      ),
    );
  }
}
