import 'package:flutter/material.dart';

abstract class AppColors {
  abstract final Color primary;
  abstract final Color onPrimary;

  abstract final Color secondary;
  abstract final Color onSecondary;

  abstract final Color background;
  abstract final Color surface;
  abstract final Color onSurface;
  abstract final Color card;

  abstract final Color text;
  abstract final Color secondaryText;

  abstract final Color success;
  abstract final Color error;
  abstract final Color warning;

  abstract final Color notificationBadge;

  const AppColors();
}

// 1. LightAppColors (الألوان للوضع الفاتح)
class LightAppColors extends AppColors {
  // الألوان الأساسية
  @override
  final Color primary = const Color(
      0xFF1A73E8); // أزرق احترافي للعلامة التجارية (مستوحى من أزرق جوجل)
  @override
  final Color onPrimary = Colors.white; // نص أبيض على الخلفية الزرقاء

  // الألوان الثانوية (للتأكيد الثانوي، الأزرار الثانوية، إلخ)
  @override
  final Color secondary =
      const Color(0xFF4285F4); // أزرق أفتح قليلاً أو لون مكمل
  @override
  final Color onSecondary = Colors.white; // نص أبيض على الخلفية الثانوية

  // ألوان الخلفية والأسطح
  @override
  final Color background = const Color(
      0xFFF0F2F5); // أوف-وايت ناعم للخلفية الرئيسية (خلفية فيسبوك/لينكدإن)
  @override
  final Color surface = Colors.white; // أبيض نقي للبطاقات والمربعات (سطح UI)
  @override
  final Color onSurface =
      const Color(0xFF1F2937); // نص داكن على الأسطح البيضاء (رمادي داكن جداً)
  @override
  final Color card =
      Colors.white; // البطاقات غالبًا ما تكون بيضاء في الوضع الفاتح

  // ألوان النصوص
  @override
  final Color text =
      const Color(0xFF1F2937); // لون النص الأساسي (نفس onSurface)
  @override
  final Color secondaryText = const Color(
      0xFF6B7280); // نص ثانوي (مثل التواريخ، الوصف، الرمادي المتوسط)

  // ألوان حالات النظام (النجاح، الخطأ، التحذير)
  @override
  final Color success = const Color(0xFF4CAF50); // أخضر للنجاح
  @override
  final Color error = const Color(0xFFF44336); // أحمر للخطأ
  @override
  final Color warning = const Color(0xFFFFC107); // أصفر/برتقالي للتحذير

  // لون شارة الإشعارات
  @override
  final Color notificationBadge =
      const Color(0xFFD32F2F); // أحمر داكن للإشعارات (يلفت الانتباه)

  const LightAppColors();
}

class DarkAppColors extends AppColors {
  // الألوان الأساسية (نفس الألوان الأساسية للوضع الفاتح للحفاظ على هوية العلامة التجارية)
  @override
  final Color primary = const Color(0xFF1A73E8); // أزرق احترافي
  @override
  final Color onPrimary = Colors.white; // نص أبيض

  // الألوان الثانوية (نفس الألوان الثانوية للوضع الفاتح)
  @override
  final Color secondary = const Color(0xFF4285F4); // أزرق أفتح قليلاً
  @override
  final Color onSecondary = Colors.white; // نص أبيض

  // ألوان الخلفية والأسطح (داكنة)
  @override
  final Color background = const Color(
      0xFF121212); // أسود داكن جداً (قريب من الماتيريال ديزاين دارك)
  @override
  final Color surface = const Color(
      0xFF1E1E1E); // رمادي داكن للبطاقات والمربعات (أفتح قليلاً من الخلفية)
  @override
  final Color onSurface =
      const Color(0xFFE0E0E0); // نص فاتح على الأسطح الداكنة (رمادي فاتح)
  @override
  final Color card = const Color(
      0xFF1E1E1E); // البطاقات غالبًا ما تكون رمادية داكنة في الوضع الداكن

  // ألوان النصوص (فاتحة لتتناسب مع الخلفية الداكنة)
  @override
  final Color text =
      const Color(0xFFE0E0E0); // لون النص الأساسي (نفس onSurface)
  @override
  final Color secondaryText =
      const Color(0xFFA0A0A0); // نص ثانوي (رمادي متوسط فاتح)

  // ألوان حالات النظام (يمكن أن تكون هي نفسها أو معدلة قليلاً لتناسب الخلفية الداكنة)
  @override
  final Color success = const Color(
      0xFF66BB6A); // أخضر أفتح قليلاً للنجاح (أفضل على الخلفية الداكنة)
  @override
  final Color error = const Color(0xFFEF5350); // أحمر أفتح قليلاً للخطأ
  @override
  final Color warning = const Color(0xFFFFD54F); // أصفر أفتح قليلاً للتحذير

  // لون شارة الإشعارات (نفس اللون)
  @override
  final Color notificationBadge =
      const Color(0xFFD32F2F); // أحمر داكن للإشعارات

  const DarkAppColors();
}
