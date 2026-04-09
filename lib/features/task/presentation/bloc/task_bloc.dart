import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/task/domain/entities/task_entity.dart';
import 'package:task_manager/features/task/domain/usecases/create_task_usecase.dart';
import 'package:task_manager/features/task/domain/usecases/delete_task_usecase.dart';
import 'package:task_manager/features/task/domain/usecases/get_tasks_usecase.dart';
import 'package:task_manager/features/task/domain/usecases/update_task_usecase.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasksUseCase getTasksUseCase;
  final CreateTaskUseCase createTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;

  TaskBloc({
    required this.getTasksUseCase,
    required this.createTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
  }) : super(const TaskLoadingState()) {
    on<LoadTasksEvent>(_onLoad);
    on<AddTaskEvent>(_onAdd);
    on<UpdateTaskEvent>(_onUpdate);
    on<DeleteTaskEvent>(_onDelete);
  }

  Future<void> _onLoad(LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(const TaskLoadingState());
    try {
      final tasks = await getTasksUseCase();
      emit(TaskLoadedState(tasks));
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }

  Future<void> _onAdd(AddTaskEvent event, Emitter<TaskState> emit) async {
    final current = state;
    try {
      final created = await createTaskUseCase(event.task);
      final tasks = current is TaskLoadedState
          ? [...current.tasks, created]
          : [created];
      emit(TaskLoadedState(tasks));
    } catch (_) {
      // Keep current state on failure; UI shows snackbar via listener if desired
      if (current is TaskLoadedState) emit(current);
    }
  }

  Future<void> _onUpdate(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    final current = state;
    if (current is! TaskLoadedState) return;
    try {
      final updated = await updateTaskUseCase(event.task);
      final tasks = current.tasks
          .map((t) => t.id == updated.id ? updated : t)
          .toList();
      emit(TaskLoadedState(tasks));
    } catch (_) {
      emit(current);
    }
  }

  Future<void> _onDelete(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    final current = state;
    if (current is! TaskLoadedState) return;
    try {
      await deleteTaskUseCase(event.taskId);
      final tasks = current.tasks.where((t) => t.id != event.taskId).toList();
      emit(TaskLoadedState(tasks));
    } catch (_) {
      emit(current);
    }
  }

  /// Convenience: get current tasks list or empty list.
  List<TaskEntity> get currentTasks =>
      state is TaskLoadedState ? (state as TaskLoadedState).tasks : [];
}
