import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/core/helpers/app_exception.dart';
import 'package:ecommerce/core/consts/api_endpoints.dart';
import 'package:ecommerce/core/blocs/auth/auth_bloc.dart';
import 'package:ecommerce/core/blocs/auth/auth_events.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/helpers/AppHelper.dart';
import '../../../../core/models/auth_model.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthBloc _authBloc;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginCubit({required AuthBloc authBloc})
      : _authBloc = authBloc,
        super(const LoginState());

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    emit(state.copyWith(status: AsyncStatus.loading, clearError: true));

    try {
      final response = await AppHelper.apiService.post(
        ApiEndpoint.login,
        data: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim()
        },
      );

      final authModel = AuthModel.fromMap(response);
      _authBloc.add(AuthLoggedIn(authModel: authModel));

      emit(state.copyWith(status: AsyncStatus.success));
    } on AppException catch (e) {
      print("LoginCubit: Login failed - ${e.drfErrors.allMessages}");
      emit(state.copyWith(
          status: AsyncStatus.failure, error: e.drfErrors.allMessages));
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
