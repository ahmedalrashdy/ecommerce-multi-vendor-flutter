import 'dart:convert';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/consts/api_endpoints.dart';
import 'package:ecommerce/core/consts/simple_cache_keys.dart';
import 'package:ecommerce/core/helpers/app_exception.dart';
import '../../helpers/AppHelper.dart';
import '../../models/auth_model.dart';
import 'auth_events.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthAppStarted>(_onAppStarted);
    on<AuthLoggedIn>(_onLoggedIn);
    on<AuthLoggedOut>(_onLoggedOut);
    on<LoginRequiredEvent>(_loginRequired);
  }

  AuthModel? get currentAuthModel {
    if (state is AuthAuthenticated) {
      return (state as AuthAuthenticated).authModel;
    }
    return null;
  }

  bool get isAuth => state is AuthAuthenticated;

  void _onAppStarted(AuthAppStarted event, Emitter<AuthState> emit) {
    emit(AuthLoading());
    try {
      final accessToken = AppHelper.accessToken;
      final refreshToken = AppHelper.refreshToken;
      final userJson = AppHelper.sharedPref.getString(SimpleCacheKeys.user);

      if (accessToken != null && refreshToken != null && userJson != null) {
        final authModel = AuthModel.fromMap({
          "access_token": accessToken,
          "refresh_token": refreshToken,
          "user": jsonDecode(userJson),
        });
        AppHelper.apiService.setAuthToken(authModel.accessToken);

        emit(AuthAuthenticated(authModel: authModel));
      } else {
        AppHelper.apiService.removeAuthToken();
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      print("Failed to get cached user: $e. Forcing logout.");
      AppHelper.apiService.removeAuthToken();
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoggedIn(AuthLoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      AppHelper.apiService.setAuthToken(event.authModel.accessToken);

      await AppHelper.secureStorageService.write(
          key: SimpleCacheKeys.accessToken, value: event.authModel.accessToken);
      await AppHelper.secureStorageService.write(
          key: SimpleCacheKeys.refreshToken,
          value: event.authModel.refreshToken);

      await AppHelper.sharedPref.setString(
          SimpleCacheKeys.user, jsonEncode(event.authModel.user.toJson()));

      emit(AuthAuthenticated(
        authModel: event.authModel,
      ));
    } catch (e) {
      AppHelper.apiService.removeAuthToken();
      emit(AuthFailure(
          message: "Failed to save login session: ${e.toString()}"));
    }
  }

  Future<void> _onLoggedOut(
      AuthLoggedOut event, Emitter<AuthState> emit) async {
    if (state is AuthAuthenticated) {
      final currentAuth = (state as AuthAuthenticated).authModel;
      emit(AuthUnauthenticated());

      try {
        await AppHelper.apiService.post(ApiEndpoint.logout,
            data: {"refresh_token": currentAuth.refreshToken});
      } on AppException catch (e) {
        print(
            "Logout API call failed, but proceeding with local logout. Error: $e");
      } finally {
        await AppHelper.secureStorageService
            .delete(key: SimpleCacheKeys.accessToken);
        await AppHelper.secureStorageService
            .delete(key: SimpleCacheKeys.refreshToken);
        await AppHelper.sharedPref.remove(SimpleCacheKeys.user);
        AppHelper.apiService.removeAuthToken();
      }
    } else if (state is! AuthUnauthenticated) {
      emit(AuthUnauthenticated());
    }
  }

  void _loginRequired(LoginRequiredEvent event, Emitter<AuthState> emit) {
    emit(
        LoginRequired(message: event.message, timestamp: DateTime.timestamp()));
  }
}
