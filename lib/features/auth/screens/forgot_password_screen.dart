// lib/features/auth/screens/forgot_password_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import '../../../core/consts/app_routes.dart';
import '../../../core/enums/enums.dart';
import '../../../core/helpers/app_message.dart';
import '../../../core/helpers/app_validator.dart';
import '../blocs/reset password/reset_password_cubit.dart';
import '../blocs/reset password/reset_password_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_form_text_field.dart';
import '../widgets/reset_password_header.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(),
      child: const ForgotPasswordView(),
    );
  }
}

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: BlocListener<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state.sendEmailStatus == AsyncStatus.success) {
            final email = context.read<ResetPasswordCubit>().emailForOtpScreen;
            context.push(
                '${AppRoutes.verifyOtpScreen}?email=${Uri.encodeComponent(email)}&isResetPassword=true');
          }
          if (state.sendEmailStatus == AsyncStatus.failure &&
              state.sendEmailError != null) {
            AppMessage.showError(message: state.sendEmailError!);
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
                        title: "هل نسيت كلمة المرور؟",
                        subTitle:
                            "لا تقلق! أدخل بريدك الإلكتروني المسجل وسنرسل لك رمزًا لإعادة التعيين.",
                      ),
                      const SizedBox(height: 32),
                      CustomFormTextField(
                        controller: emailController,
                        icon: Icons.email_outlined,
                        label: "البريد الإلكتروني",
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidator.isEmail,
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                        builder: (context, state) {
                          return CustomButton(
                            title: "إرسال الرمز",
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context
                                    .read<ResetPasswordCubit>()
                                    .requestPasswordReset(
                                        emailController.text.trim());
                              }
                            },
                            isLoading:
                                state.sendEmailStatus == AsyncStatus.loading,
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      TextButton.icon(
                        onPressed: () => context.pop(),
                        icon: Icon(Icons.arrow_back_ios,
                            size: 16, color: context.colors.primary),
                        label: Text(
                          "العودة لتسجيل الدخول",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: context.colors.primary),
                        ),
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
