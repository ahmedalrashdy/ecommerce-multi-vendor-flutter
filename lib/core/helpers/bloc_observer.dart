import 'package:flutter_bloc/flutter_bloc.dart';
import 'AppHelper.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    AppHelper.logger.t('🆕 Bloc Created: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    AppHelper.logger.d('📨 Event: ${bloc.runtimeType} => $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    AppHelper.logger
        .w('🔸 ${bloc.runtimeType} - Current State: ${change.currentState}');
    AppHelper.logger
        .w('🔹 ${bloc.runtimeType} - Next State: ${change.nextState}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    AppHelper.logger.d('📨 Event: ${transition.event}');
    AppHelper.logger.d(
        '🔸 ${bloc.runtimeType} - Current State: ${transition.currentState}');
    AppHelper.logger
        .d('🔹 ${bloc.runtimeType} - Next State: ${transition.nextState}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    AppHelper.logger.e(
      '❌ Error in ${bloc.runtimeType}: $error',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}
