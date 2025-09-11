import 'package:equatable/equatable.dart';
import 'package:ecommerce/core/enums/enums.dart';

class AccountSettingsState extends Equatable {
  AsyncStatus status;
  SupportedLangs currentLang;
  AccountSettingsState(
      {this.status = AsyncStatus.idle,
      this.currentLang = SupportedLangs.system});
  @override
  List<Object?> get props => [
        status,
        currentLang,
      ];

  AccountSettingsState copyWith({
    SupportedLangs? currentLang,
    AsyncStatus? status,
  }) {
    return AccountSettingsState(
        currentLang: currentLang ?? this.currentLang,
        status: status ?? this.status);
  }
}
