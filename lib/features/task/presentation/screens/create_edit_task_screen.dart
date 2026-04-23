import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/task/domain/entities/task_entity.dart';
import 'package:task_manager/features/task/presentation/cubit/task_cubit.dart';
import 'package:task_manager/features/task/presentation/widgets/assign_user_row.dart';
import 'package:task_manager/features/task/presentation/widgets/due_date_row.dart';
import 'package:task_manager/features/task/presentation/widgets/priority_selector_chips.dart';
import 'package:task_manager/features/task/presentation/widgets/status_selector_chips.dart';
import 'package:task_manager/features/task/presentation/widgets/task_badges.dart';
import 'package:task_manager/features/task/presentation/widgets/task_form_description_field.dart';
import 'package:task_manager/features/task/presentation/widgets/task_form_title_field.dart';
import 'package:task_manager/features/task/presentation/widgets/user_picker_bottom_sheet.dart';


class CreateEditTaskScreen extends StatefulWidget {
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

    final cubit = context.read<TaskCubit>();

    if (widget.isEditing) {
      final updated = widget.taskToEdit!.copyWith(
        title: _titleController.text.trim(),
        description: _descController.text.trim().isEmpty? null: _descController.text.trim(),
        status: _status,
        priority: _priority,
        dueDate: _dueDate,
        clearDueDate: _dueDate == null,
        assignedUser: _assignedUser,
        clearAssignedUser: _assignedUser == null,
      );
      cubit.updateTask(updated);
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
      cubit.addTask(newTask);
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

  Future<void> _showUserPicker() async {
    final users = await context.read<TaskCubit>().getUsers();
    if (!mounted) return;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: kCardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => UserPickerBottomSheet(
        users: users,
        selectedUser: _assignedUser,
        onSelected: (user) {
          setState(() => _assignedUser = user);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _fieldLabel(String text) => Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 13),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDark,
      appBar: AppBar(
        backgroundColor: kBgDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
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
              TaskFormTitleField(controller: _titleController),
              const SizedBox(height: 16),
              _fieldLabel('Description'),
              const SizedBox(height: 6),
              TaskFormDescriptionField(controller: _descController),
              const SizedBox(height: 20),
              _fieldLabel('Status'),
              const SizedBox(height: 10),
              StatusSelectorChips(
                selected: _status,
                onChanged: (s) => setState(() => _status = s),
              ),
              const SizedBox(height: 20),
              _fieldLabel('Priority'),
              const SizedBox(height: 10),
              PrioritySelectorChips(
                selected: _priority,
                onChanged: (p) => setState(() => _priority = p),
              ),
              const SizedBox(height: 20),
              DueDateRow(
                dueDate: _dueDate,
                onTap: _pickDate,
              ),
              const SizedBox(height: 12),
              AssignUserRow(
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
}

