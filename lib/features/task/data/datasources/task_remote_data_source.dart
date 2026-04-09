import 'package:dio/dio.dart';
import 'package:task_manager/core/app_constants.dart';
import 'package:task_manager/core/error/exceptions.dart';
import 'package:task_manager/features/task/data/models/task_model.dart';

class TaskRemoteDataSource {
  final Dio dio;

  TaskRemoteDataSource(this.dio);

  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}${AppConstants.tasksEndpoint}',
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
      final response = await dio.post(
        '${AppConstants.baseUrl}${AppConstants.tasksEndpoint}',
        data: task.toJson(),
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
      final response = await dio.put(
        '${AppConstants.baseUrl}${AppConstants.tasksEndpoint}/${task.id}',
        data: task.toJson(),
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
