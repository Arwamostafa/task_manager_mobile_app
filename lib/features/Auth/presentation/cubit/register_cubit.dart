import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/error/exceptions.dart';
import 'package:task_manager/features/Auth/domain/usecases/register_usecase.dart';
import 'package:task_manager/features/Auth/presentation/cubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit({required this.registerUseCase}) : super(const RegisterInitial());

  Future<void> register(String email, String password, String name) async {
    emit(const RegisterLoading());
    try {
      await registerUseCase(email, password, name);
      emit(const RegisterSuccess());
    } on ServerException catch (ex) {
      emit(RegisterFailure(ex.message));
    } catch (_) {
      emit(const RegisterFailure('Something went wrong. Please try again.'));
    }
  }
}
