import 'package:flutter/material.dart';
import 'package:task_manager/features/task/domain/entities/task_entity.dart';
import 'package:task_manager/features/task/presentation/widgets/dot_badge.dart';
import 'package:task_manager/features/task/presentation/widgets/task_badges.dart';

class StatusBadge extends StatelessWidget {
  final TaskStatus status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = statusColor(status);
    return DotBadge(color: color, label: statusLabel(status));
  }
}
