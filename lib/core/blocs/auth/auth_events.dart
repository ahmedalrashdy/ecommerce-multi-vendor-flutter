import 'package:equatable/equatable.dart';

import '../../models/auth_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthAppStarted extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {
  final AuthModel authModel;

  const AuthLoggedIn({required this.authModel});

  @override
  List<Object?> get props => [authModel];
}

class AuthLoggedOut extends AuthEvent {}

class LoginRequiredEvent extends AuthEvent {
  final String message;
  const LoginRequiredEvent({
    required this.message,
  });

  @override
  List<Object?> get props => [
        message,
      ];
}
