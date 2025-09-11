import 'package:flutter/material.dart';
import '../extensions/app_colors_extension.dart';
import 'app_colors.dart';

class AppTheme {
  static final AppColors _lightColors = LightAppColors();
  static final AppColors _darkColors = DarkAppColors();
  static AppColorsExtension appLightColorsExtension = AppColorsExtension(
    primary: _lightColors.primary,
    onPrimary: _lightColors.onPrimary,
    secondary: _lightColors.secondary,
    onSecondary: _lightColors.onSecondary,
    background: _lightColors.background,
    surface: _lightColors.surface,
    onSurface: _lightColors.onSurface,
    card: _lightColors.card,
    text: _lightColors.text,
    secondaryText: _lightColors.secondaryText,
    success: _lightColors.success,
    error: _lightColors.error,
    warning: _lightColors.warning,
    notificationBadge: _lightColors.notificationBadge,
  );

  static final AppColorsExtension appDarkColorsExtension = AppColorsExtension(
    primary: _darkColors.primary,
    onPrimary: _darkColors.onPrimary,
    secondary: _darkColors.secondary,
    onSecondary: _darkColors.onSecondary,
    background: _darkColors.background,
    surface: _darkColors.surface,
    onSurface: _darkColors.onSurface,
    card: _darkColors.card,
    text: _darkColors.text,
    secondaryText: _darkColors.secondaryText,
    success: _darkColors.success,
    error: _darkColors.error,
    warning: _darkColors.warning,
    notificationBadge: _darkColors.notificationBadge,
  );

  static ThemeData lightTheme(String fontFamily) => ThemeData(
        brightness: Brightness.light,
        fontFamily: fontFamily,
        fontFamilyFallback: [fontFamily != "Cairo" ? "Cairo" : "OpenSans"],
        scaffoldBackgroundColor: _lightColors.background,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: _lightColors.primary,
          onPrimary: _lightColors.onPrimary,
          secondary: _lightColors.secondary,
          onSecondary: _lightColors.onSecondary,
          error: _lightColors.error,
          onError: Colors.white,
          surface: _lightColors.surface,
          onSurface: _lightColors.onSurface,
        ),
        cardColor: _lightColors.card,
        extensions: [appLightColorsExtension],
      );

  static ThemeData darkTheme(String fontFamily) => ThemeData(
        brightness: Brightness.dark,
        fontFamily: fontFamily,
        fontFamilyFallback: [fontFamily != "Cairo" ? "Cairo" : "OpenSans"],
        scaffoldBackgroundColor: _darkColors.background,
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: _darkColors.primary,
          onPrimary: _darkColors.onPrimary,
          secondary: _darkColors.secondary,
          onSecondary: _darkColors.onSecondary,
          error: _darkColors.error,
          onError: Colors.black,
          surface: _darkColors.surface,
          onSurface: _darkColors.onSurface,
        ),
        cardColor: _darkColors.card,
        extensions: [appDarkColorsExtension],
      );
}
