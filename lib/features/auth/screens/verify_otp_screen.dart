import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/core/blocs/auth/auth_bloc.dart';
import 'package:ecommerce/core/blocs/auth/auth_state.dart';
import 'package:ecommerce/core/consts/app_routes.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import 'package:ecommerce/features/auth/widgets/otp_input.dart';
import 'package:ecommerce/features/auth/widgets/resend_otp_timer.dart';
import '../../../core/enums/enums.dart';
import '../../../core/helpers/app_message.dart';
import '../blocs/verify otp/verify_otp_cubit.dart';
import '../blocs/verify otp/verify_otp_state.dart';

class VerifyOtpScreen extends StatelessWidget {
  final String email;
  final bool isResetPassword;

  const VerifyOtpScreen({
    required this.email,
    this.isResetPassword = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerifyOtpCubit(
        authBloc: BlocProvider.of<AuthBloc>(context),
        email: email,
        isResetPassword: isResetPassword,
      ),
      child: VerifyOtpView(isResetPassword: isResetPassword, email: email),
    );
  }
}

class VerifyOtpView extends StatelessWidget {
  final bool isResetPassword;
  final String email;

  const VerifyOtpView(
      {super.key, required this.isResetPassword, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) => !isResetPassword,
            listener: (context, authState) {
              if (authState is AuthAuthenticated) {
                context.go(AppRoutes.mainScreen);
              }
            },
          ),
          BlocListener<VerifyOtpCubit, VerifyOtpState>(
            listener: (context, state) {
              if (isResetPassword &&
                  state.verifyStatus == AsyncStatus.success &&
                  state.resetToken != null) {
                context.push(
                    '${AppRoutes.resetPassword}?resetToken=${Uri.encodeComponent(state.resetToken!)}');
              }
              if (state.verifyStatus == AsyncStatus.failure &&
                  state.verifyError != null) {
                AppMessage.showError(message: state.verifyError!);
              }
              if (state.resendStatus == AsyncStatus.success) {
                AppMessage.showInfo(
                    message: "تم إرسال رمز جديد إلى بريدك الإلكتروني.");
              }
              if (state.resendStatus == AsyncStatus.failure &&
                  state.resendError != null) {
                AppMessage.showError(message: state.resendError!);
              }
            },
          ),
        ],
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.colors.primary.withOpacity(0.1),
                context.colors.background,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  _buildHeader(context),
                  const SizedBox(height: 40),
                  Text(
                    'تم إرسال رمز مكون من 6 أرقام إلى بريدك الإلكتروني:\n$email',
                    style: TextStyle(
                        fontSize: 16,
                        color: context.colors.onSurface.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
                    builder: (context, state) {
                      return OTPInput(
                        hasError: state.verifyStatus == AsyncStatus.failure,
                        onSubmit: (otp) {
                          if (isResetPassword) {
                            context.read<VerifyOtpCubit>().verifyOtp(otp);
                          } else {
                            context.read<VerifyOtpCubit>().verifyOtp(otp);
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
                    builder: (context, state) {
                      return ResendOtpTimer(
                        initialCooldown: state.cooldownSeconds,
                        resendStatus: state.resendStatus,
                        onResend: () =>
                            context.read<VerifyOtpCubit>().resendOtp(),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildBackButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colors.surface,
            boxShadow: [
              BoxShadow(
                  color: context.colors.primary.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 5)),
            ],
          ),
          child: Icon(Icons.shield_outlined,
              size: 50, color: context.colors.primary),
        ),
        const SizedBox(height: 24),
        Text(
          'التحقق من صحة البريد الإلكتروني',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: context.colors.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        if (!isResetPassword) {
          context.read<VerifyOtpCubit>().clearRegistrationCache();
        }
        context.pop();
      },
      icon: Icon(Icons.arrow_back_ios,
          size: 16, color: context.colors.onSurface.withOpacity(0.8)),
      label: Text(
        isResetPassword ? 'العودة لطلب الرمز' : 'تغيير البريد الإلكتروني',
        style: TextStyle(
            fontSize: 15, color: context.colors.onSurface.withOpacity(0.8)),
      ),
    );
  }
}
