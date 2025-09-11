import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/core/consts/app_routes.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import 'package:ecommerce/core/helpers/AppHelper.dart';
import 'package:ecommerce/core/models/user_model.dart';
import '../blocs/theme/theme_cubit.dart';
import '../blocs/theme/theme_state.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});
  final UserModel currentUser = AppHelper.authBloc.currentAuthModel!.user;
  @override
  Widget build(BuildContext context) {
    final appColors = context.colors;
    return Drawer(
      backgroundColor: appColors.background,
      shape: RoundedRectangleBorder(),
      child: Column(
        // padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(context),
          Spacer(),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.settings_outlined,
            text: 'الإعدادات',
            onTap: () {
              context.push("/settings");
            },
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    final appColors = context.colors;
    return UserAccountsDrawerHeader(
      accountName: Text(
        currentUser.name ?? "?", // سيتم استبداله بالبيانات الحقيقية لاحقاً
        style: TextStyle(
          color: appColors.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      accountEmail: Text(
        currentUser.email,
        style: TextStyle(color: appColors.onPrimary.withOpacity(0.8)),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: appColors.onPrimary,
        child: Text(
          currentUser.name?.isNotEmpty == true
              ? currentUser.name![0]
              : "?", // الحرف الأول من اسم المستخدم
          style: TextStyle(fontSize: 40.0, color: appColors.primary),
        ),
      ),
      decoration: BoxDecoration(
        color: appColors.primary, // استخدام اللون الأساسي من الثيم
      ),
    );
  }

  // ويدجت خاصة لعناصر القائمة لتجنب تكرار الكود
  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required BuildContext context,
    Color? color, // لون مخصص اختياري
  }) {
    final appColors = context.colors;
    final itemColor =
        color ?? appColors.text; // استخدم اللون الممرر أو لون النص الافتراضي

    return ListTile(
      leading: Icon(icon, color: itemColor),
      title: Text(text, style: TextStyle(color: itemColor)),
      onTap: onTap,
    );
  }

  Widget _buildThemeSwitcher(BuildContext context) {
    final appColors = context.colors;
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDarkMode = state.themeMode == ThemeMode.dark;
        return SwitchListTile(
          title: Text(
            'الوضع الداكن',
            style: TextStyle(color: appColors.text),
          ),
          value: isDarkMode,
          onChanged: (bool value) {
            context.read<ThemeCubit>().switchTheme();
          },
          secondary: Icon(
            isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            color: appColors.primary,
          ),
        );
      },
    );
  }
}
