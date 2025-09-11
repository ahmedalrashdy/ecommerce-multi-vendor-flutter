import 'package:equatable/equatable.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/models/auth_model.dart';

class VerifyOtpState extends Equatable {
  final AsyncStatus verifyStatus;
  final String? verifyError;
  final String? resetToken;
  final AuthModel? authModel;

  final AsyncStatus resendStatus;
  final String? resendError;
  final int cooldownSeconds;

  const VerifyOtpState({
    this.verifyStatus = AsyncStatus.idle,
    this.verifyError,
    this.resetToken,
    this.authModel,
    this.resendStatus = AsyncStatus.idle,
    this.resendError,
    this.cooldownSeconds = 0,
  });

  VerifyOtpState copyWith({
    AsyncStatus? verifyStatus,
    String? verifyError,
    bool clearVerifyError = false,
    String? resetToken,
    bool clearResetToken = false,
    AuthModel? authModel,
    bool clearAuthModel = false,
    AsyncStatus? resendStatus,
    String? resendError,
    bool clearResendError = false,
    int? cooldownSeconds,
    bool clearAll = false, // Helper to clear all OTP-related states
  }) {
    if (clearAll) {
      return VerifyOtpState(
        verifyStatus: verifyStatus ?? this.verifyStatus, // usually loading
        resendStatus: this.resendStatus, // keep resend status
      );
    }
    return VerifyOtpState(
      verifyStatus: verifyStatus ?? this.verifyStatus,
      verifyError: clearVerifyError ? null : verifyError ?? this.verifyError,
      resetToken: clearResetToken ? null : resetToken ?? this.resetToken,
      authModel: clearAuthModel ? null : authModel ?? this.authModel,
      resendStatus: resendStatus ?? this.resendStatus,
      resendError: clearResendError ? null : resendError ?? this.resendError,
      cooldownSeconds: cooldownSeconds ?? this.cooldownSeconds,
    );
  }

  @override
  List<Object?> get props => [
        verifyStatus,
        verifyError,
        resetToken,
        authModel,
        resendStatus,
        resendError,
        cooldownSeconds,
      ];
}
