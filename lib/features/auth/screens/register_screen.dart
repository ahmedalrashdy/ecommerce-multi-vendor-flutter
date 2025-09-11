// lib/features/auth/screens/register_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/core/consts/app_assets.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import 'package:ecommerce/core/widgets/logo_widget.dart';
import '../../../core/consts/app_routes.dart';
import '../../../core/enums/enums.dart';
import '../../../core/helpers/app_message.dart';
import '../../../core/helpers/app_validator.dart';
import '../blocs/register/register_cubit.dart';
import '../blocs/register/register_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_form_text_field.dart';
import '../widgets/login_register_prompt.dart';
import '../widgets/login_social_section.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // لا حاجة لـ GetIt، الـ Cubit لا يعتمد على شيء الآن
      create: (context) => RegisterCubit(),
      child: const RegisterView(),
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state.status == AsyncStatus.success) {
            final email = context.read<RegisterCubit>().emailController.text;
            // الانتقال إلى شاشة التحقق مع تمرير البريد الإلكتروني
            context.push(
                '${AppRoutes.verifyOtpScreen}?email=${Uri.encodeComponent(email)}');
          }
          if (state.status == AsyncStatus.failure &&
              state.generalError != null) {
            AppMessage.showError(message: state.generalError!);
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.colors.primary.withOpacity(0.1),
                context.colors.background,
                context.colors.background,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: BlocBuilder<RegisterCubit, RegisterState>(
                  builder: (context, state) {
                    final cubit = context.read<RegisterCubit>();
                    return Form(
                      key: cubit.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          const AuthHeader(
                            title: "إنشاء حساب جديد",
                            description: "انضم إلينا الآن وابدأ رحلتك",
                            assetPath: AppAssets.imagesLogo,
                            logo: LogoWidget(),
                            heroTag: 'logo',
                          ),
                          const SizedBox(height: 30),
                          CustomFormTextField(
                            controller: cubit.nameController,
                            icon: Icons.person_outline,
                            label: "الاسم الكامل",
                            validator: AppValidator.isRequired,
                            errorMessage:
                                state.validationErrors["name"]?.join(', '),
                          ),
                          const SizedBox(height: 16),
                          CustomFormTextField(
                            controller: cubit.emailController,
                            icon: Icons.email_outlined,
                            label: "البريد الإلكتروني",
                            keyboardType: TextInputType.emailAddress,
                            validator: AppValidator.isEmail,
                            errorMessage:
                                state.validationErrors["email"]?.join(', '),
                          ),
                          const SizedBox(height: 16),
                          CustomFormTextField(
                            controller: cubit.passwordController,
                            icon: Icons.lock_outline,
                            label: "كلمة المرور",
                            obscureText: state.obscurePassword,
                            hasPasswordToggle: true,
                            onTogglePassword: cubit.togglePasswordVisibility,
                            validator: AppValidator.isValidPassword,
                            errorMessage:
                                state.validationErrors["password"]?.join(', '),
                          ),
                          const SizedBox(height: 16),
                          CustomFormTextField(
                            controller: cubit.passwordConfirmationController,
                            icon: Icons.lock_outline,
                            label: "تأكيد كلمة المرور",
                            obscureText: state.obscureConfirmPassword,
                            hasPasswordToggle: true,
                            onTogglePassword:
                                cubit.toggleConfirmPasswordVisibility,
                            validator: (value) =>
                                AppValidator.isPasswordMatched(
                                    value, cubit.passwordController.text),
                            errorMessage:
                                state.validationErrors["password2"]?.join(', '),
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            title: "إنشاء حساب",
                            isLoading: state.status == AsyncStatus.loading,
                            onPressed: () {
                              if (cubit.formKey.currentState!.validate()) {
                                cubit.register();
                              }
                            },
                          ),
                          const SizedBox(height: 24),
                          const SocialLoginSection(),
                          const SizedBox(height: 24),
                          AuthPrompt(
                            promptText: "لديك حساب بالفعل؟",
                            actionText: "سجل الدخول",
                            onActionPressed: () =>
                                context.go(AppRoutes.loginScreen),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
