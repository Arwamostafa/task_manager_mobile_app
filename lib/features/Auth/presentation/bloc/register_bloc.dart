import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/Auth/domain/usecases/register_usecase.dart';
import 'package:task_manager/core/error/exceptions.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterBloc({required this.registerUseCase}) : super(const RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(RegisterSubmitted event, Emitter<RegisterState> emit) async {
    emit(const RegisterLoading());
    try {
      await registerUseCase(event.email, event.password, event.name);
      emit(const RegisterSuccess());
    } on ServerException catch (e) {
      emit(RegisterFailure(e.message));
    } catch (_) {
      emit(const RegisterFailure('An unexpected error occurred.'));
    }
  }
}
