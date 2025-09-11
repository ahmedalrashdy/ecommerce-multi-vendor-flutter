import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color background;
  final Color surface;
  final Color onSurface;
  final Color card;
  final Color text;
  final Color secondaryText;
  final Color success;
  final Color error;
  final Color warning;
  final Color notificationBadge;

  const AppColorsExtension({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.background,
    required this.surface,
    required this.onSurface,
    required this.card,
    required this.text,
    required this.secondaryText,
    required this.success,
    required this.error,
    required this.warning,
    required this.notificationBadge,
  });

  @override
  AppColorsExtension copyWith({
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? background,
    Color? surface,
    Color? onSurface,
    Color? card,
    Color? text,
    Color? secondaryText,
    Color? success,
    Color? error,
    Color? warning,
    Color? notificationBadge,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      card: card ?? this.card,
      text: text ?? this.text,
      secondaryText: secondaryText ?? this.secondaryText,
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      notificationBadge: notificationBadge ?? this.notificationBadge,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      card: Color.lerp(card, other.card, t)!,
      text: Color.lerp(text, other.text, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      notificationBadge:
          Color.lerp(notificationBadge, other.notificationBadge, t)!,
    );
  }
}
