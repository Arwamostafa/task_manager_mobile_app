import 'package:flutter/material.dart';
import 'package:task_manager/features/task/domain/entities/task_entity.dart';
import 'package:task_manager/features/task/presentation/widgets/task_badges.dart';

class StatusSelectorChips extends StatelessWidget {
  final TaskStatus selected;
  final ValueChanged<TaskStatus> onChanged;
  
  const StatusSelectorChips({
    super.key, 
    required this.selected, 
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: TaskStatus.values.map((s) {
        final isSelected = s == selected;
        final color = statusColor(s); // Make sure this helper is imported
        
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(s),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.08)
                      : kFieldBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? color : Colors.white12,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isSelected) ...[
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      statusLabel(s), // Make sure this helper is imported
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white54,
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}