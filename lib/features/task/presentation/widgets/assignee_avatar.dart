import 'package:flutter/material.dart';
import 'package:task_manager/features/task/presentation/widgets/task_badges.dart';

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
