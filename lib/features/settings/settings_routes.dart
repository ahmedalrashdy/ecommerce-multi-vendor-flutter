import 'package:ecommerce/core/consts/app_routes.dart';
import 'package:ecommerce/core/models/user_address_model.dart';
import 'package:ecommerce/features/addresses/screens/add_edit_address_screen.dart';
import 'package:ecommerce/features/addresses/screens/user_address_screen.dart';
import 'package:ecommerce/features/settings/screens/content_display_settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/account_settings_screen.dart';
import 'screens/settings_home_screen.dart';

final settingsRoutes = [
  GoRoute(
    path: '/settings',
    builder: (context, state) => const SettingsHomeScreen(),
    routes: [
      GoRoute(
        path: 'account',
        builder: (context, state) => AccountSettingsScreen(),
      ),
      GoRoute(
          path: AppRoutes.userAddresses,
          name: AppRoutes.userAddressesName,
          builder: (context, state) => UserAddressesScreen(),
          routes: [
            GoRoute(
              path: AppRoutes.createEditUserAddressScreen,
              name: AppRoutes.createEditUserAddressScreenName,
              builder: (context, state) {
                return AddEditAddressScreen(
                  address: state.extra as UserAddressModel?,
                );
              },
            )
          ]),
      GoRoute(
        path: 'display',
        builder: (context, state) => ContentDisplayScreen(),
      ),
      // 6. Help & Support
      GoRoute(
        path: 'help',
        builder: (context, state) => Container(
          child: Scaffold(
            body: Center(
              child: Text("Help"),
            ),
          ),
        ),
      ),
    ],
  ),
];
