import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/task/presentation/widgets/chip.dart';
import 'package:task_manager/features/task/presentation/widgets/primary_button.dart';
import 'package:task_manager/features/task/domain/entities/task_entity.dart';
import 'package:task_manager/features/task/presentation/cubit/task_cubit.dart';
import 'package:task_manager/features/task/presentation/screens/create_edit_task_screen.dart';
import 'package:task_manager/features/task/presentation/widgets/assignee_avatar.dart';
import 'package:task_manager/features/task/presentation/widgets/delete_button.dart';
import 'package:task_manager/features/task/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:task_manager/features/task/presentation/widgets/info_row.dart';
import 'package:task_manager/features/task/presentation/widgets/status_badge.dart';
import 'package:task_manager/features/task/presentation/widgets/task_badges.dart';

import 'package:task_manager/di/injection_container.dart' as di;

class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<TaskCubit>()..loadTaskById(taskId),
      child: Scaffold(
        backgroundColor: kBgDark,
        appBar: AppBar(
          backgroundColor: kBgDark,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Task details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: Colors.white12),
          ),
        ),
        body: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            if (state is TaskLoadingState) {
              return const Center(
                child: CircularProgressIndicator(color: kPurple),
              );
            }
            if (state is TaskErrorState) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white54),
                ),
              );
            }
            if (state is TaskLoadedState) {
              final task = state.tasks.firstWhere((t) => t.id == taskId);
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => _openEdit(context, task),
                          child: const Text(
                            'Edit',
                            style: TextStyle(color: kPurple, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Created ${formatDateLong(task.createdAt)}',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        BadgeChip(child:StatusBadge(status: task.status)),
                        const SizedBox(width: 10),
                        BadgeChip(child:PriorityBadge(priority: task.priority)),
                      ],
                    ),
                    if (task.description != null &&
                        task.description!.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: kCardBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Description',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              task.description!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    InfoRow(
                      label: 'Due date',
                      trailing: task.dueDate != null
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  formatDateLong(task.dueDate),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.white38,
                                  size: 16,
                                ),
                              ],
                            )
                          : const Text(
                              'No due date',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 14,
                              ),
                            ),
                    ),
                    const SizedBox(height: 10),
                    InfoRow(
                      label: 'Assigned to',
                      trailing: task.assignedUser != null
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AssigneeAvatar(
                                  initials: task.assignedUser!.initials,
                                  size: 28,
                                  fontSize: 10,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  task.assignedUser!.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            )
                          : const Text(
                              'Unassigned',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 14,
                              ),
                            ),
                    ),
                    const SizedBox(height: 36),
                    PrimaryButton(
                      label: 'Edit task',
                      onPressed: () => _openEdit(context, task),
                    ),
                    const SizedBox(height: 12),
                    DeleteButton(
                      onPressed: () => _confirmDelete(context, task),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  void _openEdit(BuildContext parentContext, TaskEntity task) {
    Navigator.of(parentContext)
        .push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: parentContext.read<TaskCubit>(),
              child: CreateEditTaskScreen(taskToEdit: task),
            ),
          ),
        )
        .then((_) {
          if (!parentContext.mounted) return;
          // Reload on return
          parentContext.read<TaskCubit>().loadTaskById(taskId);
        });
  }

  void _confirmDelete(BuildContext parentContext, TaskEntity task) {
    showDialog<void>(
      context: parentContext,
      builder: (_) => DeleteConfirmationDialog(
        taskTitle: task.title,
        onConfirm: () {
          parentContext.read<TaskCubit>().deleteTask(task.id);
          Navigator.of(parentContext).pop();
        },
      ),
    );
  }
}


