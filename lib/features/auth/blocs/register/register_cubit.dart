import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/core/consts/simple_cache_keys.dart';
import 'package:ecommerce/core/helpers/app_exception.dart';
import 'package:ecommerce/core/consts/api_endpoints.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/helpers/AppHelper.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  RegisterCubit() : super(const RegisterState());

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    emit(state.copyWith(status: AsyncStatus.loading, clearErrors: true));

    try {
      final email = emailController.text.trim();
      await AppHelper.apiService.post(
        ApiEndpoint.register,
        data: {
          "email": email,
          "name": nameController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );

      await AppHelper.sharedPref
          .setString(SimpleCacheKeys.registerEmail, email);

      print("RegisterCubit: Registration API call successful for $email");
      emit(state.copyWith(status: AsyncStatus.success));
    } on AppException catch (e) {
      print("RegisterCubit: Registration failed - ${e.drfErrors.allMessages}");
      if (e.type == AppExceptionType.validation) {
        emit(state.copyWith(
          status: AsyncStatus.failure,
          validationErrors: e.drfErrors.errors,
        ));
      } else {
        emit(state.copyWith(
          status: AsyncStatus.failure,
          generalError: e.drfErrors.allMessages,
        ));
      }
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    return super.close();
  }
}
