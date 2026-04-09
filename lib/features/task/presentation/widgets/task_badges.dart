import 'package:flutter/material.dart';
import 'package:task_manager/features/task/domain/entities/task_entity.dart';

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

class StatusBadge extends StatelessWidget {
  final TaskStatus status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = statusColor(status);
    return _DotBadge(color: color, label: statusLabel(status));
  }
}

class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = priorityColor(priority);
    return _DotBadge(color: color, label: priorityLabel(priority));
  }
}

class _DotBadge extends StatelessWidget {
  final Color color;
  final String label;
  const _DotBadge({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ── assignee avatar ─────────────────────────────────────────────────────────

class AssigneeAvatar extends StatelessWidget {
  final String initials;
  final double size;
  final double fontSize;
  const AssigneeAvatar({
    super.key,
    required this.initials,
    this.size = 30,
    this.fontSize = 11,
  });

  static const _colors = [
    kPurple,
    Color(0xFF00BCD4),
    Color(0xFFFF7043),
    Color(0xFF66BB6A),
  ];

  Color get _color => _colors[initials.codeUnitAt(0) % _colors.length];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
