import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/Auth/domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is AppStarted) {
        final hasToken = await authRepository.hasToken();
        if (hasToken) {
          emit(const AuthAuthenticated());
        } else {
          emit(const AuthUnauthenticated());
        }
      } else if (event is LoggedIn) {
        emit(const AuthAuthenticated());
      } else if (event is LoggedOut) {
        await authRepository.logout();
        emit(const AuthUnauthenticated());
      }
    });
  }
}
