import 'package:task_manager/features/task/domain/entities/task_entity.dart';

abstract class TaskState {
  const TaskState();
}

class TaskLoadingState extends TaskState {
  const TaskLoadingState();
}

class TaskLoadedState extends TaskState {
  final List<TaskEntity> tasks;
  const TaskLoadedState(this.tasks);
}

class TaskErrorState extends TaskState {
  final String message;
  const TaskErrorState(this.message);
}
