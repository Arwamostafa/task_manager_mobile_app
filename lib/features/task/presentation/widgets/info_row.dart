import 'package:flutter/material.dart';
import 'package:task_manager/features/task/presentation/widgets/task_badges.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final Widget trailing;
  const InfoRow({super.key, required this.label, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          trailing,
        ],
      ),
    );
  }
}

