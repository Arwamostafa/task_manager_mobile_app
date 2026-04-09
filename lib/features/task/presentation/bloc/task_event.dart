import 'package:task_manager/features/task/domain/entities/task_entity.dart';

abstract class TaskEvent {
  const TaskEvent();
}

class LoadTasksEvent extends TaskEvent {
  const LoadTasksEvent();
}

class AddTaskEvent extends TaskEvent {
  final TaskEntity task;
  const AddTaskEvent(this.task);
}

class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;
  const UpdateTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  const DeleteTaskEvent(this.taskId);
}
