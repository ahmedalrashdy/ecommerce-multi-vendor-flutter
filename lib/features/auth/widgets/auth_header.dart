import 'package:flutter/material.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String description;
  final String assetPath;
  final String heroTag;
  final Widget? logo;
  const AuthHeader({
    super.key,
    required this.title,
    required this.description,
    required this.assetPath,
    required this.heroTag,
    this.logo,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        logo != null
            ? logo!
            : Hero(
                tag: heroTag,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, // لون الخلفية للدائرة يبقى أبيض
                    boxShadow: [
                      BoxShadow(
                        // استخدام AppHelper للون الظل
                        color: context.colors.primary.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 20,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    assetPath,
                    height: 80,
                  ),
                ),
              ),
        const SizedBox(height: 10),
        ShaderMask(
          // استخدام AppHelper للألوان في التدرج اللوني
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              context.colors.primary,
              context.colors.secondary,
            ],
          ).createShader(bounds),
          child: Text(
            title,
            // تطبيق الأنماط مباشرة
            style: const TextStyle(
              fontSize: 24, // حجم خط كبير للعنوان الرئيسي
              fontWeight: FontWeight.bold,
              color: Colors.white, // يجب أن يكون أبيض ليعمل الـ ShaderMask
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          // تطبيق الأنماط مباشرة واستخدام AppHelper للون
          style: TextStyle(
            fontSize: 16, // حجم خط مناسب للوصف
            color: context.colors.onSurface,
          ),
          textAlign: TextAlign.center, // محاذاة النص للوسط لتحسين المظهر
        ),
      ],
    );
  }
}
