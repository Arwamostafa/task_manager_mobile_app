import 'package:task_manager/features/Auth/data/datasources/auth_local_data_source.dart';
import 'package:task_manager/features/Auth/data/datasources/auth_remote_data_source.dart';
import 'package:task_manager/features/Auth/domain/entities/user.dart';
import 'package:task_manager/features/Auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> login(String email, String password) async {
    final userModel = await remoteDataSource.login(email, password);
    await localDataSource.cacheToken(userModel.token);
    if (userModel.userId != null) {
      await localDataSource.saveUserId(userModel.userId!);
    }
    return userModel.toEntity();
  }

  @override
  Future<User> register(String email, String password, String name) async {
    final userModel = await remoteDataSource.register(email, password, name);
    await localDataSource.cacheToken(userModel.token);
    if (userModel.userId != null) {
      await localDataSource.saveUserId(userModel.userId!);
    }
    return userModel.toEntity();
  }

  @override
  Future<bool> hasToken() async {
    final token = localDataSource.getToken();
    return token != null;
  }

  @override
  Future<void> logout() async {
    await localDataSource.deleteToken();
  }
}
