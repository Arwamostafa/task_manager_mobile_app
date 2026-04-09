import 'package:task_manager/features/task/domain/repositories/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository repository;
  DeleteTaskUseCase(this.repository);

  Future<void> call(String taskId) => repository.deleteTask(taskId);
}
