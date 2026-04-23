import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/task/domain/entities/task_entity.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';
import 'task_state.dart';

export 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository repository;

  TaskCubit({required this.repository}) : super(const TaskLoadingState());

  Future<List<AppUser>> getUsers() => repository.getUsers();

  Future<void> loadTasks() async {
    emit(const TaskLoadingState());
    try {
      final tasks = await repository.getTasks();
      emit(TaskLoadedState(tasks));
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }

  Future<void> addTask(TaskEntity task) async {
    final current = state;
    try {
      final created = await repository.createTask(task);
      final tasks = current is TaskLoadedState
          ? [...current.tasks, created]
          : [created];
      emit(TaskLoadedState(tasks));
    } catch (_) {
      if (current is TaskLoadedState) emit(current);
    }
  }

  Future<void> updateTask(TaskEntity task) async {
    final current = state;
    if (current is! TaskLoadedState) return;
    try {
      final updated = await repository.updateTask(task);
      final tasks =
          current.tasks.map((t) => t.id == updated.id ? updated : t).toList();
      emit(TaskLoadedState(tasks));
    } catch (_) {
      emit(current);
    }
  }

  Future<void> deleteTask(String taskId) async {
    final current = state;
    if (current is! TaskLoadedState) return;
    try {
      await repository.deleteTask(taskId);
      final tasks = current.tasks.where((t) => t.id != taskId).toList();
      emit(TaskLoadedState(tasks));
    } catch (_) {
      emit(current);
    }
  }
  Future<void> loadTaskById(String taskId) async {
    emit(const TaskLoadingState());
    try {
      final task = await repository.getTaskById(taskId);
      emit(TaskLoadedState([task]));
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }

  List<TaskEntity> get currentTasks =>
      state is TaskLoadedState ? (state as TaskLoadedState).tasks : [];
}
