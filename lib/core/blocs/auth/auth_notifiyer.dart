import 'dart:async';
import 'package:flutter/foundation.dart';
import 'auth_bloc.dart';
import 'auth_state.dart';

class AuthRouterNotifier extends ChangeNotifier {
  final AuthBloc authBloc;
  late StreamSubscription<AuthState> _authSubscription;

  bool _isLoggedIn = false;

  AuthRouterNotifier(this.authBloc) {
    _isLoggedIn = authBloc.isAuth;
    _authSubscription = authBloc.stream.listen((authState) {
      final newStateIsLoggedIn = authState is AuthAuthenticated;
      if (_isLoggedIn != newStateIsLoggedIn) {
        _isLoggedIn = newStateIsLoggedIn;
        notifyListeners();
      }
    });
  }

  bool get isLoggedIn => _isLoggedIn;

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
