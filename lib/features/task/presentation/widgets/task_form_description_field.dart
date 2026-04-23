import 'package:flutter/material.dart';
import 'package:task_manager/features/task/presentation/widgets/task_badges.dart';

class TaskFormDescriptionField extends StatefulWidget {
  final TextEditingController controller;
  
  const TaskFormDescriptionField({super.key, required this.controller});

  @override
  State<TaskFormDescriptionField> createState() => _TaskFormDescriptionFieldState();
}

class _TaskFormDescriptionFieldState extends State<TaskFormDescriptionField> {
  static const _maxLength = 200;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          controller: widget.controller,
          maxLines: 4,
          maxLength: _maxLength,
          buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
              null,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: kFieldBg,
            hintText: 'Add description...',
            hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kPurple, width: 1.5),
            ),
            contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
          ),
        ),
        Positioned(
          right: 12,
          bottom: 10,
          child: Text(
            '${widget.controller.text.length}/$_maxLength',
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ),
      ],
    );
  }
}