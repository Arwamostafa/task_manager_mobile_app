import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/task/domain/entities/task_entity.dart';
import 'package:task_manager/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager/features/task/presentation/bloc/task_event.dart';
import 'package:task_manager/features/task/presentation/widgets/task_badges.dart';

class CreateEditTaskScreen extends StatefulWidget {
  /// Pass null to create a new task, or a [TaskEntity] to edit an existing one.
  final TaskEntity? taskToEdit;

  const CreateEditTaskScreen({super.key, this.taskToEdit});

  bool get isEditing => taskToEdit != null;

  @override
  State<CreateEditTaskScreen> createState() => _CreateEditTaskScreenState();
}

class _CreateEditTaskScreenState extends State<CreateEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;

  late TaskStatus _status;
  late TaskPriority _priority;
  DateTime? _dueDate;
  AppUser? _assignedUser;

  @override
  void initState() {
    super.initState();
    final t = widget.taskToEdit;
    _titleController = TextEditingController(text: t?.title ?? '');
    _descController = TextEditingController(text: t?.description ?? '');
    _status = t?.status ?? TaskStatus.todo;
    _priority = t?.priority ?? TaskPriority.low;
    _dueDate = t?.dueDate;
    _assignedUser = t?.assignedUser;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final bloc = context.read<TaskBloc>();

    if (widget.isEditing) {
      final updated = widget.taskToEdit!.copyWith(
        title: _titleController.text.trim(),
        description: _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
        status: _status,
        priority: _priority,
        dueDate: _dueDate,
        clearDueDate: _dueDate == null,
        assignedUser: _assignedUser,
        clearAssignedUser: _assignedUser == null,
      );
      bloc.add(UpdateTaskEvent(updated));
      // Pop back so TaskDetailScreen also gets dismissed cleanly.
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else {
      final newTask = TaskEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
        status: _status,
        priority: _priority,
        dueDate: _dueDate,
        assignedUser: _assignedUser,
        createdAt: DateTime.now(),
      );
      bloc.add(AddTaskEvent(newTask));
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: kPurple),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _showUserPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: kCardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _UserPickerSheet(
        selectedUser: _assignedUser,
        onSelected: (user) {
          setState(() => _assignedUser = user);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDark,
      appBar: AppBar(
        backgroundColor: kBgDark,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.chevron_left, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.isEditing ? 'Edit task' : 'New task',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: widget.isEditing
            ? [
                TextButton(
                  onPressed: _save,
                  child: const Text(
                    'Save',
                    style: TextStyle(color: kPurple, fontSize: 15),
                  ),
                ),
              ]
            : null,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fieldLabel('Title *'),
              const SizedBox(height: 6),
              _TitleField(controller: _titleController),
              const SizedBox(height: 16),
              _fieldLabel('Description'),
              const SizedBox(height: 6),
              _DescriptionField(controller: _descController),
              const SizedBox(height: 20),
              _fieldLabel('Status'),
              const SizedBox(height: 10),
              _StatusSelector(
                selected: _status,
                onChanged: (s) => setState(() => _status = s),
              ),
              const SizedBox(height: 20),
              _fieldLabel('Priority'),
              const SizedBox(height: 10),
              _PrioritySelector(
                selected: _priority,
                onChanged: (p) => setState(() => _priority = p),
              ),
              const SizedBox(height: 20),
              _DueDateRow(
                dueDate: _dueDate,
                onTap: _pickDate,
              ),
              const SizedBox(height: 12),
              _AssignRow(
                assignedUser: _assignedUser,
                onTap: _showUserPicker,
                onClear: () => setState(() => _assignedUser = null),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    widget.isEditing ? 'Save changes' : 'Save task',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) => Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 13),
      );
}

// ── Title field ─────────────────────────────────────────────────────────────

class _TitleField extends StatelessWidget {
  final TextEditingController controller;
  const _TitleField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: kFieldBg,
        hintText: 'Enter task title',
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPurple, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF5252)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF5252)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Title is required' : null,
    );
  }
}

// ── Description field ────────────────────────────────────────────────────────

class _DescriptionField extends StatefulWidget {
  final TextEditingController controller;
  const _DescriptionField({required this.controller});

  @override
  State<_DescriptionField> createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<_DescriptionField> {
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

// ── Status selector ──────────────────────────────────────────────────────────

class _StatusSelector extends StatelessWidget {
  final TaskStatus selected;
  final ValueChanged<TaskStatus> onChanged;
  const _StatusSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: TaskStatus.values.map((s) {
        final isSelected = s == selected;
        final color = statusColor(s);
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
                      statusLabel(s),
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

// ── Priority selector ────────────────────────────────────────────────────────

class _PrioritySelector extends StatelessWidget {
  final TaskPriority selected;
  final ValueChanged<TaskPriority> onChanged;
  const _PrioritySelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: TaskPriority.values.map((p) {
        final isSelected = p == selected;
        final color = priorityColor(p);
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(p),
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
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      priorityLabel(p),
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

// ── Due date row ─────────────────────────────────────────────────────────────

class _DueDateRow extends StatelessWidget {
  final DateTime? dueDate;
  final VoidCallback onTap;
  const _DueDateRow({required this.dueDate, required this.onTap});

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
            Text(
              'Due date',
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
            Row(
              children: [
                Text(
                  dueDate != null
                      ? formatDateLong(dueDate)
                      : 'Pick a date...',
                  style: TextStyle(
                    color:
                        dueDate != null ? Colors.white : Colors.white38,
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

// ── Assign to row ─────────────────────────────────────────────────────────────

class _AssignRow extends StatelessWidget {
  final AppUser? assignedUser;
  final VoidCallback onTap;
  final VoidCallback onClear;
  const _AssignRow({
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
                        style:
                            TextStyle(color: kPurple, fontSize: 13),
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

// ── User picker bottom sheet ──────────────────────────────────────────────────

class _UserPickerSheet extends StatelessWidget {
  final AppUser? selectedUser;
  final ValueChanged<AppUser> onSelected;

  const _UserPickerSheet({
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
          ...mockUsers.map(
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
