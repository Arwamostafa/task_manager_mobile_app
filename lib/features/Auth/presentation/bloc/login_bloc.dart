import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/error/exceptions.dart';
import 'package:task_manager/features/Auth/domain/usecases/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(const LoginState.initial()) {
    on<LoginEvent>((event, emit) async {
      await event.map(
        loginSubmitted: (e) async {
          emit(const LoginState.loading());
          try {
            await loginUseCase(e.email, e.password);
            emit(const LoginState.success());
          } on ServerException catch (ex) {
            emit(LoginState.failure(ex.message));
          } catch (_) {
            emit(const LoginState.failure('Something went wrong. Please try again.'));
          }
        },
      );
    });
  }
}
