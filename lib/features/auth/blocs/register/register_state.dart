import 'package:equatable/equatable.dart';
import '../../../../core/enums/enums.dart';

class RegisterState extends Equatable {
  final AsyncStatus status;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final Map<String, List<String>> validationErrors;
  final String? generalError;

  const RegisterState({
    this.status = AsyncStatus.idle,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.validationErrors = const {},
    this.generalError,
  });

  RegisterState copyWith({
    AsyncStatus? status,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    Map<String, List<String>>? validationErrors,
    String? generalError,
    bool clearErrors = false,
  }) {
    return RegisterState(
      status: status ?? this.status,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
      validationErrors:
          clearErrors ? const {} : validationErrors ?? this.validationErrors,
      generalError: clearErrors ? null : generalError ?? this.generalError,
    );
  }

  @override
  List<Object?> get props => [
        status,
        obscurePassword,
        obscureConfirmPassword,
        validationErrors,
        generalError
      ];
}
