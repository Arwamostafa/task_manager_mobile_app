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
      String? message;
      if (e.response?.data is Map) {
         message = (e.response?.data as Map)['message'] as String? ?? (e.response?.data as Map).values.first.toString();
      } else if (e.response?.data is String) {
         message = e.response?.data as String;
      }
      throw ServerException(message: message ?? 'Invalid email or password.');
    } catch (_) {
      throw const ServerException(message: 'Something went wrong. Please try again.');
    }
  }

  Future<UserModel> register(String email, String password, String name) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}${AppConstants.registerEndpoint}',
        data: {'email': email, 'password': password, 'name': name},
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const ServerException(message: 'Connection timed out. Please check your network.');
      }
      if (e.type == DioExceptionType.connectionError || e.response == null) {
        throw const ServerException(message: 'Cannot connect to server. Make sure the server is running.');
      }
      String? message;
      if (e.response?.data is Map) {
        message = (e.response?.data as Map)['message'] as String?;
        message ??= (e.response?.data as Map).values.first.toString();
      } else if (e.response?.data is String) {
        message = e.response?.data as String;
      }
      throw ServerException(message: message ?? 'Registration failed.');
    } catch (_) {
      throw const ServerException(message: 'Something went wrong. Please try again.');
    }
  }
}
