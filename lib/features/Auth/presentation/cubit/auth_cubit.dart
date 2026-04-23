import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/Auth/domain/repositories/auth_repository.dart';
import 'package:task_manager/features/Auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(const AuthInitial());

  Future<void> appStarted() async {
    final hasToken = await authRepository.hasToken();
    if (hasToken) {
      emit(const AuthAuthenticated());
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  void loggedIn() => emit(const AuthAuthenticated());

  Future<void> loggedOut() async {
    await authRepository.logout();
    emit(const AuthUnauthenticated());
  }
}
