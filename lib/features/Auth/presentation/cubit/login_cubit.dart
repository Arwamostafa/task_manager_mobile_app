import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/error/exceptions.dart';
import 'package:task_manager/features/Auth/domain/usecases/login_usecase.dart';
import 'package:task_manager/features/Auth/presentation/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit({required this.loginUseCase}) : super(const LoginInitial());

  Future<void> login(String email, String password) async {
    emit(const LoginLoading());
    try {
      await loginUseCase(email, password);
      emit(const LoginSuccess());
    } on ServerException catch (ex) {
      emit(LoginFailure(ex.message));
    } catch (_) {
      emit(const LoginFailure('Something went wrong. Please try again.'));
    }
  }
}
