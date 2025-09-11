import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/core/blocs/locale/locale_cubit.dart';
import 'package:ecommerce/core/enums/enums.dart';

import 'account_settings_state.dart';

class AccountSettingsCubit extends Cubit<AccountSettingsState> {
  LocaleCubit localeCubit;
  AccountSettingsCubit({required this.localeCubit})
      : super(AccountSettingsState(
            currentLang:
                SupportedLangs.fromValue(LocaleCubit.currentLangCode)));

  void changeLang(String langCode) {
    emit(state.copyWith(currentLang: SupportedLangs.fromValue(langCode)));
    localeCubit.changeLocale(langCode);
  }
}
