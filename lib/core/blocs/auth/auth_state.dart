import 'package:equatable/equatable.dart';
import '../../models/auth_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AuthModel authModel;
  bool get isProfileComplete => authModel.user.isProfileComplete;

  const AuthAuthenticated({required this.authModel});

  @override
  List<Object?> get props => [authModel, isProfileComplete];
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class LoginRequired extends AuthState {
  final String message;
  final DateTime timestamp;
  const LoginRequired({required this.message, required this.timestamp});

  @override
  List<Object?> get props => [message, timestamp];
}
