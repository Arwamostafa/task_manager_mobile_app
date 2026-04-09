import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/task/domain/entities/task_entity.dart';
import 'package:task_manager/features/task/domain/usecases/get_task_by_id_usecase.dart';

abstract class TaskDetailsEvent {}

class LoadTaskDetails extends TaskDetailsEvent {
  final String taskId;
  LoadTaskDetails(this.taskId);
}

abstract class TaskDetailsState {}

class TaskDetailsLoading extends TaskDetailsState {}

class TaskDetailsLoaded extends TaskDetailsState {
  final TaskEntity task;
  TaskDetailsLoaded(this.task);
}

class TaskDetailsError extends TaskDetailsState {
  final String message;
  TaskDetailsError(this.message);
}

class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  final GetTaskByIdUseCase getTaskByIdUseCase;

  TaskDetailsBloc({required this.getTaskByIdUseCase}) : super(TaskDetailsLoading()) {
    on<LoadTaskDetails>((event, emit) async {
      emit(TaskDetailsLoading());
      try {
        final task = await getTaskByIdUseCase(event.taskId);
        emit(TaskDetailsLoaded(task));
      } catch (e) {
        emit(TaskDetailsError(e.toString()));
      }
    });
  }
}
