import 'package:task_manager/features/Auth/domain/entities/user.dart';
import 'package:task_manager/features/Auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String email, String password) {
    return repository.login(email, password);
  }
}
