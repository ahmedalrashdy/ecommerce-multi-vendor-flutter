import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce/core/helpers/AppHelper.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeCacheKey = 'themeMode';
  static final SharedPreferences _simpleCacheService = AppHelper.sharedPref;
  static bool isSystemMode = false;
  ThemeCubit() : super(_loadThemeFromCache()) {
    _loadThemeFromCache();
  }

  static ThemeState _loadThemeFromCache() {
    try {
      final int? themeModeIndex = _simpleCacheService.getInt(_themeCacheKey);

      isSystemMode =
          ThemeMode.system.index == themeModeIndex || themeModeIndex == null;
      final bool useDarkMode = themeModeIndex == ThemeMode.dark.index ||
          (isSystemMode && _isSystemDarkMode());

      final initialMode = useDarkMode ? ThemeMode.dark : ThemeMode.light;
      AppHelper.setNegativeColor(initialMode);
      return ThemeState(initialMode);
    } catch (e) {
      AppHelper.setNegativeColor(ThemeMode.light);
      return const ThemeState(ThemeMode.light);
    }
  }

  static bool _isSystemDarkMode() {
    try {
      var brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveThemeToCache(ThemeMode mode) async {
    try {
      await _simpleCacheService.setInt(_themeCacheKey, mode.index);
    } catch (e) {}
  }

  void switchTheme() {
    final newMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    AppHelper.setNegativeColor(newMode);
    emit(ThemeState(newMode));
    _saveThemeToCache(newMode);
  }

  void setTheme(ThemeMode mode) {
    if (mode == ThemeMode.system) {
      isSystemMode = true;
      ThemeMode mode = _isSystemDarkMode() ? ThemeMode.dark : ThemeMode.light;
      AppHelper.setNegativeColor(mode);
      emit(ThemeState(mode));
      _saveThemeToCache(ThemeMode.system);
    }
    if (state.themeMode != mode || isSystemMode) {
      isSystemMode = false;
      AppHelper.setNegativeColor(mode);
      emit(ThemeState(mode));
      _saveThemeToCache(mode);
    }
  }
}
