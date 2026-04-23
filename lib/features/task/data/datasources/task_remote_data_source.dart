import 'package:dio/dio.dart';
import 'package:task_manager/core/app_constants.dart';
import 'package:task_manager/core/error/exceptions.dart';
import 'package:task_manager/features/Auth/data/datasources/auth_local_data_source.dart';
import 'package:task_manager/features/task/data/models/task_model.dart';
import 'package:task_manager/features/task/domain/entities/task_entity.dart';

class TaskRemoteDataSource {
  final Dio dio;
  final AuthLocalDataSource localDataSource;

  TaskRemoteDataSource(this.dio, this.localDataSource);

  Future<List<AppUser>> getUsers() async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}${AppConstants.usersEndpoint}',
      );
      final list = response.data as List<dynamic>;
      return list.map((e) {
        final json = e as Map<String, dynamic>;
        final id = json['id'].toString();
        final name = json['name'] as String;
        final initials = name
            .trim()
            .split(' ')
            .where((w) => w.isNotEmpty)
            .map((w) => w[0].toUpperCase())
            .take(2)
            .join();
        return AppUser(id: id, name: name, initials: initials);
      }).toList();
    } on DioException catch (e) {
      final message = e.response?.data?['message'] as String?;
      throw ServerException(message: message ?? 'Failed to fetch users.');
    } catch (_) {
      throw const ServerException(message: 'Something went wrong.');
    }
  }

  Future<List<TaskModel>> getTasks() async {
    try {
      final userId = localDataSource.getUserId();
      final response = await dio.get(
        '${AppConstants.baseUrl}${AppConstants.tasksEndpoint}',
        queryParameters: userId != null ? {'userId': userId} : null,
      );
      final list = response.data as List<dynamic>;
      return list
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final message = e.response?.data?['message'] as String?;
      throw ServerException(message: message ?? 'Failed to fetch tasks.');
    } catch (_) {
      throw const ServerException(message: 'Something went wrong.');
    }
  }

  Future<TaskModel> getTaskById(String taskId) async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}${AppConstants.tasksEndpoint}/$taskId',
      );
      return TaskModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] as String?;
      throw ServerException(message: message ?? 'Failed to fetch task details.');
    } catch (_) {
      throw const ServerException(message: 'Something went wrong.');
    }
  }

  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final data = task.toJson();
      final userId = localDataSource.getUserId();
      if (userId != null) data['userId'] = userId;
      final response = await dio.post(
        '${AppConstants.baseUrl}${AppConstants.tasksEndpoint}',
        data: data,
      );
      return TaskModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] as String?;
      throw ServerException(message: message ?? 'Failed to create task.');
    } catch (_) {
      throw const ServerException(message: 'Something went wrong.');
    }
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final data = task.toJson();
      final userId = localDataSource.getUserId();
      if (userId != null) data['userId'] = userId;
      final response = await dio.put(
        '${AppConstants.baseUrl}${AppConstants.tasksEndpoint}/${task.id}',
        data: data,
      );
      return TaskModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] as String?;
      throw ServerException(message: message ?? 'Failed to update task.');
    } catch (_) {
      throw const ServerException(message: 'Something went wrong.');
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      await dio.delete(
        '${AppConstants.baseUrl}${AppConstants.tasksEndpoint}/$taskId',
      );
    } on DioException catch (e) {
      final message = e.response?.data?['message'] as String?;
      throw ServerException(message: message ?? 'Failed to delete task.');
    } catch (_) {
      throw const ServerException(message: 'Something went wrong.');
    }
  }
}
