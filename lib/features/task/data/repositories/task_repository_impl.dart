import 'package:task_manager/features/task/data/datasources/task_remote_data_source.dart';
import 'package:task_manager/features/task/data/models/task_model.dart';
import 'package:task_manager/features/task/domain/entities/task_entity.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TaskEntity>> getTasks() async {
    final models = await remoteDataSource.getTasks();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<TaskEntity> getTaskById(String taskId) async {
    final model = await remoteDataSource.getTaskById(taskId);
    return model.toEntity();
  }

  @override
  Future<TaskEntity> createTask(TaskEntity task) async {
    final model = await remoteDataSource.createTask(TaskModel.fromEntity(task));
    return model.toEntity();
  }

  @override
  Future<TaskEntity> updateTask(TaskEntity task) async {
    final model = await remoteDataSource.updateTask(TaskModel.fromEntity(task));
    return model.toEntity();
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final id = int.parse(taskId);
    await remoteDataSource.deleteTask(id);
  }
}
