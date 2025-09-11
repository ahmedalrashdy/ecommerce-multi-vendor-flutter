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
