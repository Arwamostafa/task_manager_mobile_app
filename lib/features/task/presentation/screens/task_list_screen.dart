import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/Auth/presentation/bloc/auth_bloc.dart';
import 'package:task_manager/features/Auth/presentation/bloc/auth_event.dart';
import 'package:task_manager/features/task/domain/entities/task_entity.dart';
import 'package:task_manager/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager/features/task/presentation/bloc/task_event.dart';
import 'package:task_manager/features/task/presentation/bloc/task_state.dart';
import 'package:task_manager/features/task/presentation/screens/create_edit_task_screen.dart';
import 'package:task_manager/features/task/presentation/screens/task_detail_screen.dart';
import 'package:task_manager/features/task/presentation/widgets/task_badges.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';
  final _filters = ['All', 'Todo', 'In Progress', 'Done'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TaskEntity> _applyFilters(List<TaskEntity> tasks) {
    final query = _searchController.text.toLowerCase();
    return tasks.where((task) {
      final matchesSearch = query.isEmpty ||
          task.title.toLowerCase().contains(query) ||
          (task.description?.toLowerCase().contains(query) ?? false);
      final matchesFilter = _selectedFilter == 'All' ||
          (_selectedFilter == 'Todo' && task.status == TaskStatus.todo) ||
          (_selectedFilter == 'In Progress' &&
              task.status == TaskStatus.inProgress) ||
          (_selectedFilter == 'Done' && task.status == TaskStatus.done);
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDark,
      body: SafeArea(
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                _buildSearchBar(),
                _buildFilterChips(),
                const SizedBox(height: 8),
                Expanded(child: _buildBody(context, state)),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPurple,
        foregroundColor: Colors.white,
        onPressed: () => _openCreate(context),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'My Tasks',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () =>
                context.read<AuthBloc>().add(const AuthEvent.loggedOut()),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: kPurple,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'S',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Search ─────────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
          prefixIcon:
              const Icon(Icons.search, color: Colors.white38, size: 20),
          filled: true,
          fillColor: kCardBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  // ── Filter chips ───────────────────────────────────────────────────────────

  Widget _buildFilterChips() {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? kPurple : kCardBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white54,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Body (loading / error / list) ──────────────────────────────────────────

  Widget _buildBody(BuildContext context, TaskState state) {
    if (state is TaskLoadingState) {
      return const Center(
        child: CircularProgressIndicator(color: kPurple),
      );
    }

    if (state is TaskErrorState) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.white38, size: 48),
            const SizedBox(height: 12),
            Text(
              state.message,
              style: const TextStyle(color: Colors.white38, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () =>
                  context.read<TaskBloc>().add(const LoadTasksEvent()),
              child: const Text('Retry', style: TextStyle(color: kPurple)),
            ),
          ],
        ),
      );
    }

    final tasks = state is TaskLoadedState
        ? _applyFilters(state.tasks)
        : <TaskEntity>[];

    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'No tasks found',
          style: TextStyle(color: Colors.white38, fontSize: 15),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      itemCount: tasks.length,
      itemBuilder: (context, index) => _TaskCard(
        task: tasks[index],
        onTap: () => _openDetail(context, tasks[index]),
      ),
    );
  }

  // ── Navigation helpers ─────────────────────────────────────────────────────

  void _openCreate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TaskBloc>(),
          child: const CreateEditTaskScreen(),
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, TaskEntity task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TaskBloc>(),
          child: TaskDetailScreen(task: task),
        ),
      ),
    );
  }
}

// ── Task card ──────────────────────────────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onTap;
  const _TaskCard({required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // Coloured left-border accent
            Container(
              width: 4,
              height: 90,
              decoration: BoxDecoration(
                color: cardBorderColor(task.status),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        StatusBadge(status: task.status),
                        const SizedBox(width: 8),
                        PriorityBadge(priority: task.priority),
                        const Spacer(),
                        if (task.dueDate != null) ...[
                          Text(
                            formatDateShort(task.dueDate),
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (task.assignedUser != null)
                          AssigneeAvatar(
                            initials: task.assignedUser!.initials[0],
                            size: 26,
                            fontSize: 11,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
