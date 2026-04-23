import 'package:task_manager/features/task/data/datasources/task_remote_data_source.dart';
import 'package:task_manager/features/task/data/models/task_model.dart';
import 'package:task_manager/features/task/domain/entities/task_entity.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AppUser>> getUsers() => remoteDataSource.getUsers();

  @override
  Future<List<TaskEntity>> getTasks() async {
    final results = await Future.wait([
      remoteDataSource.getTasks(),
      remoteDataSource.getUsers(),
    ]);
    final models = results[0] as List<TaskModel>;
    final users = results[1] as List<AppUser>;
    return models.map((m) => m.toEntity(users: users)).toList();
  }

  @override
  Future<TaskEntity> getTaskById(String taskId) async {
    final results = await Future.wait([
      remoteDataSource.getTaskById(taskId),
      remoteDataSource.getUsers(),
    ]);
    final model = results[0] as TaskModel;
    final users = results[1] as List<AppUser>;
    return model.toEntity(users: users);
  }

  @override
  Future<TaskEntity> createTask(TaskEntity task) async {
    final results = await Future.wait([
      remoteDataSource.createTask(TaskModel.fromEntity(task)),
      remoteDataSource.getUsers(),
    ]);
    return (results[0] as TaskModel).toEntity(users: results[1] as List<AppUser>);
  }

  @override
  Future<TaskEntity> updateTask(TaskEntity task) async {
    final results = await Future.wait([
      remoteDataSource.updateTask(TaskModel.fromEntity(task)),
      remoteDataSource.getUsers(),
    ]);
    return (results[0] as TaskModel).toEntity(users: results[1] as List<AppUser>);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final id = int.parse(taskId);
    await remoteDataSource.deleteTask(id);
  }
}
