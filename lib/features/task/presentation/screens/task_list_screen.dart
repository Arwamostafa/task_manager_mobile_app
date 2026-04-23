import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/Auth/presentation/cubit/auth_cubit.dart';
import 'package:task_manager/features/task/domain/entities/task_entity.dart';
import 'package:task_manager/features/task/presentation/cubit/task_cubit.dart';
import 'package:task_manager/features/task/presentation/screens/create_edit_task_screen.dart';
import 'package:task_manager/features/task/presentation/screens/task_detail_screen.dart';
import 'package:task_manager/features/task/presentation/widgets/task_badges.dart';
import 'package:task_manager/features/task/presentation/widgets/task_card.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _searchController = TextEditingController();
  String _selectedStatusFilter = 'All';
  String _selectedPriorityFilter = 'All';
  final _statusFilters = ['All', 'Todo', 'In Progress', 'Done'];
  final _priorityFilters = ['All', 'High', 'Medium', 'Low'];

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
      final matchesStatus = _selectedStatusFilter == 'All' ||
          (_selectedStatusFilter == 'Todo' && task.status == TaskStatus.todo) ||
          (_selectedStatusFilter == 'In Progress' &&
              task.status == TaskStatus.inProgress) ||
          (_selectedStatusFilter == 'Done' && task.status == TaskStatus.done);
      final matchesPriority = _selectedPriorityFilter == 'All' ||
          (_selectedPriorityFilter == 'High' &&
              task.priority == TaskPriority.high) ||
          (_selectedPriorityFilter == 'Medium' &&
              task.priority == TaskPriority.medium) ||
          (_selectedPriorityFilter == 'Low' &&
              task.priority == TaskPriority.low);
      return matchesSearch && matchesStatus && matchesPriority;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDark,
      body: SafeArea(
        child: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                _buildSearchBar(),
                _buildFilterChips(),
                const SizedBox(height: 4),
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
            onTap: () => _confirmLogout(context),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChipRow(
          label: 'Status',
          filters: _statusFilters,
          selected: _selectedStatusFilter,
          onTap: (f) => setState(() => _selectedStatusFilter = f),
        ),
        const SizedBox(height: 8),
        _buildChipRow(
          label: 'Priority',
          filters: _priorityFilters,
          selected: _selectedPriorityFilter,
          onTap: (f) => setState(() => _selectedPriorityFilter = f),
          color: const Color(0xFFFFB74D),
        ),
      ],
    );
  }

  Widget _buildChipRow({
    required String label,
    required List<String> filters,
    required String selected,
    required ValueChanged<String> onTap,
    Color color = kPurple,
  }) {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selected == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onTap(filter),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? color : kCardBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white54,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
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
                  context.read<TaskCubit>().loadTasks(),
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
      itemBuilder: (context, index) => TaskCard(
        task: tasks[index],
        onTap: () => _openDetail(context, tasks[index]),
      ),
    );
  }

  // ── Navigation helpers ─────────────────────────────────────────────────────

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1040),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A3D),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: kPurple,
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Log out?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Are you sure you want to log out?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<AuthCubit>().loggedOut();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Yes, log out',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCreate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TaskCubit>(),
          child: const CreateEditTaskScreen(),
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, TaskEntity task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TaskCubit>(),
          child: TaskDetailScreen(taskId: task.id),
        ),
      ),
    ).then((_) {
      if (!context.mounted) return;
      context.read<TaskCubit>().loadTasks();
    });
  }
}

// ── Task card ──────────────────────────────────────────────────────────────────

