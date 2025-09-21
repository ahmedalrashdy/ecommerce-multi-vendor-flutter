import 'package:ecommerce/core/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/contents/content_display_settings_cubit.dart';
import '../blocs/contents/content_display_settings_state.dart';
import '../widgets/settings_group_header.dart';
import '../widgets/settings_list_tile.dart';
import '../widgets/show_theme_options_dialog.dart';

class ContentDisplaySettings {
  double fontSizeMultiplier;
  String videoAutoplay;
  bool dataSaverMode;

  ContentDisplaySettings({
    this.fontSizeMultiplier = 1.0,
    this.videoAutoplay = 'wifi_only',
    this.dataSaverMode = false,
  });
}

class ContentDisplayScreen extends StatefulWidget {
  const ContentDisplayScreen({super.key});

  @override
  State<ContentDisplayScreen> createState() => _ContentDisplayScreenState();
}

class _ContentDisplayScreenState extends State<ContentDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ContentDisplaySettingsCubit(themeCubit: context.read<ThemeCubit>()),
      child: Builder(builder: (context) {
        return BlocBuilder<ContentDisplaySettingsCubit,
            ContentDisplaySettingsState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('المحتوى والعرض'),
              ),
              body: ListView(
                children: [
                  const SettingsGroupHeader(title: 'العرض'),
                  SettingsListTile(
                    icon: Icons.brightness_6_outlined,
                    title: 'المظهر (Theme)',
                    subtitle: state.themeMode == ThemeMode.system
                        ? 'نظام الجهاز'
                        : (state.themeMode == ThemeMode.light
                            ? 'فاتح'
                            : 'مظلم'),
                    onTap: () => showThemeDialog(context),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
