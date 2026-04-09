import 'package:task_manager/features/Auth/domain/entities/user.dart';
import 'package:task_manager/features/Auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<User> call(String email, String password, String name) async {
    return await repository.register(email, password, name);
  }
}
