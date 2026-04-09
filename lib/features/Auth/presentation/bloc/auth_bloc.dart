import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/Auth/domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      await event.map(
        appStarted: (_) async {
          final hasToken = await authRepository.hasToken();
          if (hasToken) {
            emit(const AuthState.authenticated());
          } else {
            emit(const AuthState.unauthenticated());
          }
        },
        loggedIn: (_) async {
          emit(const AuthState.authenticated());
        },
        loggedOut: (_) async {
          await authRepository.logout();
          emit(const AuthState.unauthenticated());
        },
      );
    });
  }
}
