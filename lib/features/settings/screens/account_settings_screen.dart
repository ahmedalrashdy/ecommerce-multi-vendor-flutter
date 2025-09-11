import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/core/blocs/locale/locale_cubit.dart';
import 'package:ecommerce/core/enums/enums.dart';
import 'package:ecommerce/features/settings/blocs/accounts/account_settings_cubit.dart';
import '../blocs/accounts/account_settings_state.dart';
import '../widgets/settings_group_header.dart';
import '../widgets/settings_list_tile.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountSettingsCubit(
        localeCubit: context.read<LocaleCubit>(),
      ),
      child: Builder(builder: (context) {
        return BlocConsumer<AccountSettingsCubit, AccountSettingsState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('إعدادات الحساب'),
              ),
              body: ListView(
                children: [
                  // --- Account Management Group ---
                  const SettingsGroupHeader(title: 'إدارة الحساب'),
                  SettingsListTile(
                    icon: Icons.password_outlined,
                    title: 'تغيير كلمة المرور',
                    onTap: () {
                      context.push("/check-password");
                    },
                  ),
                  SettingsListTile(
                    icon: Icons.language_outlined,
                    title: 'اللغة والمنطقة',
                    subtitle: state.currentLang.displayName,
                    onTap: () {
                      _showLanguageSelectionDialog(context);
                    },
                  ),

                  // --- Account Actions Group ---
                  // const SettingsGroupHeader(title: 'إجراءات الحساب'),
                  // SettingsListTile(
                  //   icon: Icons.pause_circle_outline,
                  //   title: 'إلغاء تنشيط الحساب',
                  //   subtitle: 'إخفاء حسابك وملفك الشخصي مؤقتًا',
                  //   iconColor: Colors.amber.shade700,
                  //   onTap: () {
                  //     _showDeactivationConfirmationDialog(context);
                  //   },
                  // ),
                  // SettingsListTile(
                  //   icon: Icons.delete_forever_outlined,
                  //   title: 'حذف الحساب نهائيًا',
                  //   subtitle: 'هذا الإجراء لا يمكن التراجع عنه',
                  //   iconColor: Theme.of(context).colorScheme.error,
                  //   onTap: () {
                  //     _showDeletionConfirmationDialog(context);
                  //   },
                  // ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  // --- Helper Dialog Methods ---

  void _showLanguageSelectionDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (dialogContext) {
          var _currentLang =
              context.read<AccountSettingsCubit>().state.currentLang.value;
          return StatefulBuilder(builder: (ctx, setState) {
            return AlertDialog(
              title: const Text('اختر اللغة'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(SupportedLangs.values.length, (index) {
                    return RadioListTile<String>(
                      title: Text(SupportedLangs.values[index].displayName),
                      value: SupportedLangs.values[index].value,
                      groupValue: _currentLang, // Current language
                      onChanged: (value) {
                        setState(() {
                          _currentLang = value!;
                        });
                      },
                    );
                  })
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    context.pop();
                    context
                        .read<AccountSettingsCubit>()
                        .changeLang(_currentLang);
                  },
                  child: const Text('موافق'),
                )
              ],
            );
          });
        });
  }

  void _showDeactivationConfirmationDialog(BuildContext context) {
    // This dialog should be very clear about the consequences.
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('إلغاء تنشيط الحساب'),
          content: const Text(
            'هل أنت متأكد؟ سيتم إخفاء ملفك الشخصي ومنشوراتك حتى تقوم بتسجيل الدخول مرة أخرى.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('تراجع'),
            ),
            TextButton(
              onPressed: () {
                // Perform deactivation logic
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'نعم، قم بإلغاء التنشيط',
                style: TextStyle(color: Colors.amber.shade700),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeletionConfirmationDialog(BuildContext context) {
    // This is the most critical dialog. It should have multiple steps
    // or very strong warnings. A simple implementation is shown here.
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'هل أنت متأكد تمامًا؟',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          content: const Text(
            'سيتم حذف حسابك وجميع بياناتك بشكل دائم. هذا الإجراء لا يمكن التراجع عنه مطلقًا.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('تراجع فورًا'),
            ),
            FilledButton(
              // Use a more prominent button for the dangerous action
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('أفهم العواقب، قم بالحذف'),
            ),
          ],
        );
      },
    );
  }
}
