import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/blocs/theme/theme_cubit.dart';
import 'content_display_settings_state.dart';

class ContentDisplaySettingsCubit extends Cubit<ContentDisplaySettingsState> {
  ThemeCubit themeCubit;
  ContentDisplaySettingsCubit({required this.themeCubit})
      : super(
            ContentDisplaySettingsState(themeMode: themeCubit.state.themeMode));

  void UpdateTheme(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
    themeCubit.setTheme(mode);
  }
}
