import 'package:dio/dio.dart';
import 'package:task_manager/core/app_constants.dart';
import 'package:task_manager/core/error/exceptions.dart';
import 'package:task_manager/features/Auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}${AppConstants.loginEndpoint}',
        data: {'email': email, 'password': password},
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] as String?;
      throw ServerException(message: message ?? 'Invalid email or password.');
    } catch (_) {
      throw const ServerException(message: 'Something went wrong. Please try again.');
    }
  }
}
