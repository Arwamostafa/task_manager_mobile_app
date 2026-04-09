import 'package:task_manager/features/Auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<bool> hasToken();
  Future<void> logout();
}
