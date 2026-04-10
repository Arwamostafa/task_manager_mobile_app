import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/error/exceptions.dart';
import 'package:task_manager/features/Auth/domain/usecases/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(const LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event is LoginSubmitted) {
        emit(const LoginLoading());
        try {
          await loginUseCase(event.email, event.password);
          emit(const LoginSuccess());
        } on ServerException catch (ex) {
          emit(LoginFailure(ex.message));
        } catch (_) {
          emit(const LoginFailure('Something went wrong. Please try again.'));
        }
      }
    });
  }
}
