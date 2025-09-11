import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce/app_router.dart';
import 'package:ecommerce/core/blocs/auth/auth_bloc.dart';
import 'package:ecommerce/core/consts/api_endpoints.dart';
import 'package:ecommerce/core/themes/app_theme.dart';
import '../../main.dart';
import '../consts/simple_cache_keys.dart';
import '../extensions/app_colors_extension.dart';
import '../services/api/api_service.dart';
import '../services/secure_storage_service.dart';

abstract class AppHelper {
  static APIService apiService = APIService(ApiEndpoint.APIBaseURL);
  static SecureStorageService secureStorageService = SecureStorageService();
  static SharedPreferences sharedPref = appSharedPref;
  static AuthBloc authBloc = AuthBloc();
  static GoRouter appRouter = AppRouter().appRouter;
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  static GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // عدد الأسطر لعرض اسم الدالة
      errorMethodCount: 8, // عدد الأسطر لعرض اسم الدالة في حالة الخطأ
      lineLength: 120,
      levelColors: {
        Level.verbose: AnsiColor.fg(8), // رمادي غامق
        Level.debug: AnsiColor.fg(10), // أخضر فاتح
        Level.info: AnsiColor.fg(12), // أزرق
        Level.warning: AnsiColor.fg(140), // برتقالي
        Level.error: AnsiColor.fg(196), // أحمر
        Level.wtf: AnsiColor.fg(93),
      },
      colors: true, // تمكين الألوان
      printEmojis: true, // طباعة الرموز التعبيرية
    ),
  );

  static String? accessToken;
  static String? refreshToken;

  static AppColorsExtension negativeColor = AppTheme.appDarkColorsExtension;

  static void setNegativeColor(ThemeMode themeMode) {
    negativeColor = themeMode == ThemeMode.dark
        ? AppTheme.appLightColorsExtension
        : AppTheme.appLightColorsExtension;
  }

  static Future<SharedPreferences> sharedPreferencesInitial() async {
    return SharedPreferences.getInstance();
  }

  static Future<void> getAuthTokens() async {
    accessToken = await AppHelper.secureStorageService
        .read(key: SimpleCacheKeys.accessToken);
    refreshToken = await AppHelper.secureStorageService
        .read(key: SimpleCacheKeys.refreshToken);
  }
}
