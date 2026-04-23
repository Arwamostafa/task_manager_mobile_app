import 'package:flutter/material.dart';
import 'package:task_manager/features/task/presentation/widgets/task_badges.dart';

class DueDateRow extends StatelessWidget {
  final DateTime? dueDate;
  final VoidCallback onTap;
  
  const DueDateRow({
    super.key, 
    required this.dueDate, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: kFieldBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Due date',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
            Row(
              children: [
                Text(
                  dueDate != null
                      ? formatDateLong(dueDate) // Make sure this helper is imported
                      : 'Pick a date...',
                  style: TextStyle(
                    color: dueDate != null ? Colors.white : Colors.white38,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white38),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.white38,
                    size: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}