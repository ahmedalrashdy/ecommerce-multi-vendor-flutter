import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import 'package:ecommerce/core/helpers/app_validator.dart';
import 'package:ecommerce/features/auth/blocs/change%20password/change_password_cubit.dart';
import 'package:ecommerce/features/auth/blocs/change%20password/change_password_state.dart';
import 'package:ecommerce/features/auth/widgets/reset_password_header.dart';
import '../../../core/enums/enums.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_form_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({
    super.key,
  });
  @override
  State<ChangePasswordScreen> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ChangePasswordScreen> {
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
      body: BlocListener<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state.status == AsyncStatus.success) {
            context.pop();
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
                      BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                        builder: (context, state) {
                          print(
                              context.read<ChangePasswordCubit>().oldPassword);
                          return CustomButton(
                            title: "حفظ كلمة المرور",
                            isLoading: state.status == AsyncStatus.loading,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context
                                    .read<ChangePasswordCubit>()
                                    .changePassword(passwordController.text);
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
