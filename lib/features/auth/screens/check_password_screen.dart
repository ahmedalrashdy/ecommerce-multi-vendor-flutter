import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import 'package:ecommerce/features/auth/blocs/change%20password/change_password_cubit.dart'; // Cubit مناسب لهذا الغرض
import 'package:ecommerce/features/auth/blocs/change%20password/change_password_state.dart';
import '../../../core/enums/enums.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_form_text_field.dart';
import '../widgets/reset_password_header.dart';

class CheckPasswordScreen extends StatelessWidget {
  const CheckPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: BlocListener<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state.status == AsyncStatus.success) {
            context.pushReplacement('/check-password/change-password');
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
                        title: " ادخل كلمة المرور الحالية",
                        subTitle:
                            "الرجاء إدخال كلمة المرور الحالية للمتابعة في تغييرها.", // تم تغيير النص الفرعي
                      ),
                      const SizedBox(height: 32),
                      CustomFormTextField(
                        controller: currentPasswordController,
                        icon: Icons.lock_outline,
                        label: "كلمة المرور الحالية",
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        validator: (value) {
                          if (value?.isEmpty ?? false) {
                            return "ادخل كلمه المرور";
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                        builder: (context, state) {
                          return CustomButton(
                            title: "ارسال", // تم تغيير عنوان الزر
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context
                                    .read<ChangePasswordCubit>()
                                    .checkPassword(
                                        currentPasswordController.text.trim());
                              }
                            },
                            isLoading: state.status == AsyncStatus.loading,
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      TextButton.icon(
                        onPressed: () => context.pop(),
                        icon: Icon(Icons.arrow_back_ios,
                            size: 16, color: context.colors.primary),
                        label: Text(
                          "العودة",
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
