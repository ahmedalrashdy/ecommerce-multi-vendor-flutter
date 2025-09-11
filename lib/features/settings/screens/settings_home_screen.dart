import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/core/blocs/auth/auth_events.dart';
import 'package:ecommerce/core/consts/app_routes.dart';
import 'package:ecommerce/core/helpers/AppHelper.dart';
import 'package:ecommerce/core/widgets/custom_confirm_diolog.dart';

import '../widgets/settings_list_tile.dart';

class SettingsHomeScreen extends StatelessWidget {
  const SettingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        children: [
          SettingsListTile(
            icon: Icons.person_outline,
            title: 'إعدادات الحساب',
            subtitle: 'المعلومات الشخصية, إدارة الحساب',
            onTap: () => context.push('/settings/account'),
          ),
          SettingsListTile(
            icon: Icons.help_outline,
            title: 'المساعدة والدعم',
            subtitle: 'مركز المساعدة, الإبلاغ عن مشكلة',
            onTap: () => context.push('/settings/help'),
          ),
          const SizedBox(height: 20),
          if (AppHelper.authBloc.isAuth)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor:
                      Theme.of(context).colorScheme.error.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => CustomConfirmationDialog(
                            content: "هل انت متأكد من انك تريد تسجيل الخروج؟",
                            title: "تسجيل الخروج",
                            onConfirm: () {
                              AppHelper.authBloc.add(AuthLoggedOut());
                              context.goNamed(AppRoutes.loginScreenName);
                            },
                            confirmText: "تسجيل الخروج",
                            isDestructive: true,
                          ));
                },
                child: Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
