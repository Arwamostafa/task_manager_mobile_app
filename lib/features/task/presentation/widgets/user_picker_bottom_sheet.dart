import 'package:flutter/material.dart';
import 'package:task_manager/features/task/domain/entities/task_entity.dart';
import 'package:task_manager/features/task/presentation/widgets/assignee_avatar.dart';
import 'package:task_manager/features/task/presentation/widgets/task_badges.dart';

class UserPickerBottomSheet extends StatelessWidget {
  final List<AppUser> users;
  final AppUser? selectedUser;
  final ValueChanged<AppUser> onSelected;

  const UserPickerBottomSheet({
    super.key,
    required this.users,
    required this.selectedUser,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Assign to',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...users.map(
            (user) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: AssigneeAvatar(initials: user.initials, size: 36),
              title: Text(
                user.name,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              trailing: selectedUser?.id == user.id
                  ? const Icon(Icons.check, color: kPurple, size: 20)
                  : null,
              onTap: () => onSelected(user),
            ),
          ),
        ],
      ),
    );
  }
}