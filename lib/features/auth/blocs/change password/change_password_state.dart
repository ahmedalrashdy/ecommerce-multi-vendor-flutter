import 'package:equatable/equatable.dart';
import 'package:ecommerce/core/enums/enums.dart';

class ChangePasswordState extends Equatable {
  AsyncStatus status;
  ChangePasswordState({this.status = AsyncStatus.idle});
  @override
  List<Object?> get props => [status];
}
