// lib/features/auth/screens/reset_password_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import 'package:ecommerce/core/helpers/app_validator.dart';
import 'package:ecommerce/features/auth/widgets/reset_password_header.dart';

import '../../../core/consts/app_routes.dart';
import '../../../core/enums/enums.dart';
import '../../../core/helpers/app_message.dart';
import '../blocs/reset password/reset_password_cubit.dart';
import '../blocs/reset password/reset_password_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_form_text_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String resetToken;

  const ResetPasswordScreen({
    required this.resetToken,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(initialResetToken: resetToken),
      child: const ResetPasswordView(),
    );
  }
}

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state.confirmResetStatus == AsyncStatus.success) {
            AppMessage.showSuccess(
                message:
                    "تم تغيير كلمة المرور بنجاح. يمكنك الآن تسجيل الدخول.");
            context.goNamed(AppRoutes.loginScreenName);
          }
          if (state.confirmResetStatus == AsyncStatus.failure &&
              state.confirmResetError != null) {
            AppMessage.showError(message: state.confirmResetError!);
          }
        },
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
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ResetPasswordHeader(
                        title: 'تعيين كلمة المرور',
                        subTitle: 'أدخل كلمة مرور جديدة قوية وآمنة.',
                      ),
                      const SizedBox(height: 32),
                      CustomFormTextField(
                        controller: passwordController,
                        icon: Icons.lock_outline,
                        label: 'كلمة المرور الجديدة',
                        obscureText: obscurePassword,
                        hasPasswordToggle: true,
                        onTogglePassword: () =>
                            setState(() => obscurePassword = !obscurePassword),
                        validator: AppValidator.isValidPassword,
                      ),
                      const SizedBox(height: 16),
                      CustomFormTextField(
                        controller: confirmPasswordController,
                        icon: Icons.lock_outline,
                        label: 'تأكيد كلمة المرور',
                        obscureText: obscureConfirmPassword,
                        hasPasswordToggle: true,
                        onTogglePassword: () => setState(() =>
                            obscureConfirmPassword = !obscureConfirmPassword),
                        validator: (value) => AppValidator.isPasswordMatched(
                            value, passwordController.text),
                      ),
                      const SizedBox(height: 32),
                      BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                        builder: (context, state) {
                          return CustomButton(
                            title: "حفظ كلمة المرور",
                            isLoading:
                                state.confirmResetStatus == AsyncStatus.loading,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context
                                    .read<ResetPasswordCubit>()
                                    .confirmPasswordReset(
                                        passwordController.text);
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
