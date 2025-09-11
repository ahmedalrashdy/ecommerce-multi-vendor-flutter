// lib/features/auth/login/cubit/login_state.dart
import 'package:equatable/equatable.dart';

import '../../../../core/enums/enums.dart';

class LoginState extends Equatable {
  final AsyncStatus status;
  final bool obscurePassword;
  final String? error; // تغيير من Failure? إلى String?

  const LoginState({
    this.status = AsyncStatus.idle,
    this.obscurePassword = true,
    this.error,
  });

  LoginState copyWith({
    AsyncStatus? status,
    bool? obscurePassword,
    String? error,
    bool clearError = false, // تم تغيير الاسم ليكون أوضح
  }) {
    return LoginState(
      status: status ?? this.status,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, obscurePassword, error];
}
