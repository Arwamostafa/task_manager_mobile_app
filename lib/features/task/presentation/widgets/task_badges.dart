import 'package:flutter/material.dart';
import 'package:task_manager/features/task/domain/entities/task_entity.dart';
import 'package:task_manager/features/task/presentation/widgets/dot_badge.dart';

// ── colours ────────────────────────────────────────────────────────────────

const kBgDark = Color(0xFF0F0F1A);
const kCardBg = Color(0xFF1A1A2E);
const kFieldBg = Color(0xFF1E1E3A);
const kPurple = Color(0xFF7C4DFF);

Color statusColor(TaskStatus s) {
  switch (s) {
    case TaskStatus.inProgress:
      return const Color(0xFF448AFF);
    case TaskStatus.todo:
      return Colors.white54;
    case TaskStatus.done:
      return const Color(0xFF00E676);
  }
}

String statusLabel(TaskStatus s) {
  switch (s) {
    case TaskStatus.inProgress:
      return 'In Progress';
    case TaskStatus.todo:
      return 'Todo';
    case TaskStatus.done:
      return 'Done';
  }
}

Color priorityColor(TaskPriority p) {
  switch (p) {
    case TaskPriority.high:
      return const Color(0xFFFF5252);
    case TaskPriority.medium:
      return const Color(0xFFFFD740);
    case TaskPriority.low:
      return const Color(0xFF00E676);
  }
}

String priorityLabel(TaskPriority p) {
  switch (p) {
    case TaskPriority.high:
      return 'High';
    case TaskPriority.medium:
      return 'Medium';
    case TaskPriority.low:
      return 'Low';
  }
}

Color cardBorderColor(TaskStatus s) {
  switch (s) {
    case TaskStatus.inProgress:
      return kPurple;
    case TaskStatus.todo:
      return const Color(0xFFFFB300);
    case TaskStatus.done:
      return const Color(0xFF00E676);
  }
}

String formatDateShort(DateTime? date) {
  if (date == null) return '';
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}';
}

String formatDateLong(DateTime? date) {
  if (date == null) return '';
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

// ── reusable badge widgets ──────────────────────────────────────────────────


class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = priorityColor(priority);
    return DotBadge(color: color, label: priorityLabel(priority));
  }
}

