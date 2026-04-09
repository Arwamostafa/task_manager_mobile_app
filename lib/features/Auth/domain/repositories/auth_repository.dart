import 'package:task_manager/features/Auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String name);
  Future<bool> hasToken();
  Future<void> logout();
}
