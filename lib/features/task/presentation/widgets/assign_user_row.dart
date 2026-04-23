import 'package:flutter/material.dart';
import 'package:task_manager/features/task/domain/entities/task_entity.dart';
import 'package:task_manager/features/task/presentation/widgets/assignee_avatar.dart';
import 'package:task_manager/features/task/presentation/widgets/task_badges.dart';

class AssignUserRow extends StatelessWidget {
  final AppUser? assignedUser;
  final VoidCallback onTap;
  final VoidCallback onClear;
  
  const AssignUserRow({
    super.key,
    required this.assignedUser,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: kFieldBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Assign to',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          assignedUser != null
              ? Row(
                  children: [
                    AssigneeAvatar(
                      initials: assignedUser!.initials,
                      size: 26,
                      fontSize: 9,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      assignedUser!.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: onTap,
                      child: const Text(
                        'Change',
                        style: TextStyle(color: kPurple, fontSize: 13),
                      ),
                    ),
                  ],
                )
              : GestureDetector(
                  onTap: onTap,
                  child: Row(
                    children: [
                      const Text(
                        'Select user...',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: kPurple,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: const Icon(Icons.add,
                            color: Colors.white, size: 14),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}