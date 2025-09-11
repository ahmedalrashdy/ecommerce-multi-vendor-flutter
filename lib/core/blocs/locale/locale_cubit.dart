import 'package:flutter/widgets.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce/core/enums/enums.dart';
import 'package:ecommerce/core/helpers/AppHelper.dart';

class LocaleCubit extends Cubit<Locale> {
  static final SharedPreferences _sharedPref = AppHelper.sharedPref;
  final String _key = 'locale';
  final String defaultLocaleCode = "ar";
  LocaleCubit() : super(_calculateInitialLocale());

  static String currentLangCode = "ar";
  static Locale _calculateInitialLocale() {
    const String storageKey = 'locale';
    String defaultLocaleCode = "ar";

    try {
      String? storedLanguageCode = _sharedPref.getString(storageKey);
      if (storedLanguageCode != null && storedLanguageCode.isNotEmpty) {
        currentLangCode = storedLanguageCode;
        if (storedLanguageCode == SupportedLangs.system.value) {
          storedLanguageCode = deviceLocaleOrDefault(defaultLocaleCode);
        }

        return Locale(storedLanguageCode);
      }

      currentLangCode = SupportedLangs.system.value;
      storedLanguageCode = deviceLocaleOrDefault(defaultLocaleCode);

      return Locale(storedLanguageCode);
    } catch (e) {
      currentLangCode = defaultLocaleCode;
      return Locale(defaultLocaleCode);
    }
  }

  static String deviceLocaleOrDefault(String defaultLocaleCode) {
    return defaultLocaleCode;
    final Locale deviceLocale =
        WidgetsBinding.instance.platformDispatcher.locale;
    return (deviceLocale.languageCode == SupportedLangs.arabic.value ||
            deviceLocale.languageCode == SupportedLangs.english.value)
        ? deviceLocale.languageCode
        : defaultLocaleCode;
  }

  Future<void> changeLocale(String languageCode) async {
    if (state.languageCode == languageCode) {
      return;
    }
    String newLocaleCode = languageCode == SupportedLangs.system.value
        ? deviceLocaleOrDefault(defaultLocaleCode)
        : languageCode;

    final newLocale = Locale(newLocaleCode);
    _sharedPref.setString(_key, languageCode);
    emit(newLocale);
  }
}
