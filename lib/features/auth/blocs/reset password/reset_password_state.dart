import 'package:equatable/equatable.dart';
import '../../../../core/enums/enums.dart';

class ResetPasswordState extends Equatable {
  final AsyncStatus sendEmailStatus;
  final String? sendEmailError;

  final AsyncStatus confirmResetStatus;
  final String? confirmResetError;

  final String? resetToken;

  const ResetPasswordState({
    this.sendEmailStatus = AsyncStatus.idle,
    this.sendEmailError,
    this.confirmResetStatus = AsyncStatus.idle,
    this.confirmResetError,
    this.resetToken,
  });

  ResetPasswordState copyWith({
    AsyncStatus? sendEmailStatus,
    String? sendEmailError,
    bool clearSendEmailError = false,
    AsyncStatus? confirmResetStatus,
    String? confirmResetError,
    bool clearConfirmResetError = false,
    String? resetToken,
  }) {
    return ResetPasswordState(
      sendEmailStatus: sendEmailStatus ?? this.sendEmailStatus,
      sendEmailError:
          clearSendEmailError ? null : sendEmailError ?? this.sendEmailError,
      confirmResetStatus: confirmResetStatus ?? this.confirmResetStatus,
      confirmResetError: clearConfirmResetError
          ? null
          : confirmResetError ?? this.confirmResetError,
      resetToken: resetToken ?? this.resetToken,
    );
  }

  @override
  List<Object?> get props => [
        sendEmailStatus,
        sendEmailError,
        confirmResetStatus,
        confirmResetError,
        resetToken,
      ];
}
