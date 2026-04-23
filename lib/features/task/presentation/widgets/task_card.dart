import 'package:flutter/material.dart';
import 'package:task_manager/features/task/domain/entities/task_entity.dart';
import 'package:task_manager/features/task/presentation/widgets/assignee_avatar.dart';
import 'package:task_manager/features/task/presentation/widgets/status_badge.dart';
import 'package:task_manager/features/task/presentation/widgets/task_badges.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onTap;
  const TaskCard({ super.key, required this.task, required this.onTap});

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

