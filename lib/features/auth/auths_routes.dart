import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/consts/app_routes.dart';
import 'blocs/change password/change_password_cubit.dart';
import 'screens/change_password_screen.dart';
import 'screens/check_password_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/verify_otp_screen.dart';

Widget _buildOTPBuilder(BuildContext context, GoRouterState state) {
  final email = state.uri.queryParameters['email'];
  final isResetPassword =
      state.uri.queryParameters['isResetPassword'] == 'true';
  if (email == null || email.isEmpty) {
    Future.microtask(() => context.goNamed('login'));
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
  return VerifyOtpScreen(email: email, isResetPassword: isResetPassword);
}

Widget _buildResetPasswordBuilder(BuildContext context, GoRouterState state) {
  final token = state.uri.queryParameters['resetToken'];
  if (token == null || token.isEmpty) {
    Future.microtask(() => context.goNamed('forgotPassword'));
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
  return ResetPasswordScreen(resetToken: token);
}

final authsRoutes = [
  GoRoute(
    path: AppRoutes.loginScreen,
    name: AppRoutes.loginScreenName,
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: AppRoutes.registerScreen,
    name: AppRoutes.registerScreenName,
    builder: (context, state) => const RegisterScreen(),
  ),
  GoRoute(
    path: AppRoutes.forgotPasswordScreen,
    name: AppRoutes.forgotPasswordScreenName,
    builder: (context, state) => const ForgotPasswordScreen(),
  ),
  GoRoute(
    path: AppRoutes.verifyOtpScreen,
    name: AppRoutes.verifyOtpScreenName,
    builder: _buildOTPBuilder,
  ),
  GoRoute(
    path: AppRoutes.resetPassword,
    name: AppRoutes.resetPasswordName,
    builder: _buildResetPasswordBuilder,
  ),
  ShellRoute(
      builder: (ctx, state, child) {
        return BlocProvider(
            create: (context) => ChangePasswordCubit(), child: child);
      },
      routes: [
        GoRoute(
            path: "/check-password",
            builder: (ctx, state) => CheckPasswordScreen(),
            routes: [
              GoRoute(
                  path: 'change-password',
                  builder: (ctx, state) {
                    return ChangePasswordScreen();
                  }),
            ]),
      ])
];
