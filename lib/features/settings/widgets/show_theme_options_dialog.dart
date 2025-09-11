import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/contents/content_display_settings_cubit.dart';

void showThemeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      var obj = context.watch<ContentDisplaySettingsCubit>();
      var _currentTheme = obj.state.themeMode;
      return BlocProvider.value(
        value: obj,
        child: AlertDialog(
          title: const Text('اختر المظهر'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<ThemeMode>(
                    title: const Text('نظام الجهاز'),
                    value: ThemeMode.system,
                    groupValue: _currentTheme,
                    onChanged: (value) => setDialogState(() {
                      _currentTheme = value!;
                      context
                          .read<ContentDisplaySettingsCubit>()
                          .UpdateTheme(value);
                    }),
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('فاتح'),
                    value: ThemeMode.light,
                    groupValue: _currentTheme,
                    onChanged: (value) => setDialogState(() {
                      _currentTheme = value!;
                      context
                          .read<ContentDisplaySettingsCubit>()
                          .UpdateTheme(value);
                    }),
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('مظلم'),
                    value: ThemeMode.dark,
                    groupValue: _currentTheme,
                    onChanged: (value) => setDialogState(() {
                      _currentTheme = value!;
                      context
                          .read<ContentDisplaySettingsCubit>()
                          .UpdateTheme(value);
                    }),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
                onPressed: () => context.pop(context),
                child: const Text('إغلاق'))
          ],
        ),
      );
    },
  );
}
