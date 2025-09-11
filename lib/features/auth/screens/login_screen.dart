// lib/features/auth/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/core/blocs/auth/auth_bloc.dart';
import 'package:ecommerce/core/blocs/auth/auth_state.dart';
import 'package:ecommerce/core/consts/app_assets.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import 'package:ecommerce/core/helpers/AppHelper.dart';
import 'package:ecommerce/core/widgets/logo_widget.dart';
import '../../../core/consts/app_routes.dart';
import '../../../core/enums/enums.dart';
import '../../../core/helpers/app_message.dart';
import '../../../core/helpers/app_validator.dart';
import '../blocs/login/login_cubit.dart';
import '../blocs/login/login_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_form_text_field.dart';
import '../widgets/forget_password.dart';
import '../widgets/login_register_prompt.dart';
import '../widgets/login_social_section.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        authBloc: AppHelper.authBloc,
      ),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, authState) {
              if (authState is AuthAuthenticated) {
                context.go(AppRoutes.mainScreen);
              }
            },
          ),
          BlocListener<LoginCubit, LoginState>(
            listenWhen: (previous, current) =>
                previous.status != current.status &&
                current.status == AsyncStatus.failure,
            listener: (context, loginState) {
              if (loginState.error != null) {
                AppMessage.showError(message: loginState.error!);
              }
            },
          ),
        ],
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
                child: BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    final cubit = context.read<LoginCubit>();
                    return Form(
                      key: cubit.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 40),
                          const AuthHeader(
                            title: "مرحباً بعودتك",
                            description: "سجل الدخول للمتابعة إلى حسابك",
                            assetPath: AppAssets.imagesLogo,
                            logo: LogoWidget(),
                            heroTag: 'logo',
                          ),
                          const SizedBox(height: 32),
                          CustomFormTextField(
                            controller: cubit.emailController,
                            icon: Icons.email_outlined,
                            label: "البريد الإلكتروني",
                            keyboardType: TextInputType.emailAddress,
                            validator: AppValidator.isEmail,
                          ),
                          const SizedBox(height: 16),
                          CustomFormTextField(
                            controller: cubit.passwordController,
                            icon: Icons.lock_outline,
                            label: "كلمة المرور",
                            obscureText: state.obscurePassword,
                            hasPasswordToggle: true,
                            onTogglePassword: cubit.togglePasswordVisibility,
                            validator: AppValidator.isRequired,
                          ),
                          const SizedBox(height: 8),
                          const ForgotPasswordButton(),
                          const SizedBox(height: 16),
                          CustomButton(
                            title: "تسجيل الدخول",
                            isLoading: state.status == AsyncStatus.loading,
                            onPressed: () {
                              if (cubit.formKey.currentState!.validate()) {
                                cubit.login();
                              }
                            },
                          ),
                          const SizedBox(height: 32),
                          const SocialLoginSection(),
                          const SizedBox(height: 24),
                          AuthPrompt(
                            promptText: "ليس لديك حساب؟",
                            actionText: "أنشئ حساباً",
                            onActionPressed: () =>
                                context.push(AppRoutes.registerScreen),
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
