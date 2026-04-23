import 'package:task_manager/features/task/domain/entities/task_entity.dart';

class TaskModel {
  final int id;
  final String title;
  final String? description;
  final String status;
  final String priority;
  final String? dueDate;
  final int? assignedTo;
  final int? userId; // Placeholder user ID for API compatibility

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    this.assignedTo,
    this.userId, 
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
      priority: json['priority'] as String,
      dueDate: json['dueDate'] as String?,
      assignedTo: json['assignedTo'] as int?,
      userId: json['userId'] as int?, // Placeholder user ID for API compatibility
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'dueDate': dueDate,
      'assignedTo': assignedTo,
      'userId': userId, 
    };
  }

  TaskEntity toEntity({List<AppUser> users = const []}) {
    return TaskEntity(
      id: id.toString(),
      title: title,
      description: description,
      status: _parseStatus(status),
      priority: _parsePriority(priority),
      dueDate: dueDate != null ? DateTime.tryParse(dueDate!) : null,
      assignedUser: assignedTo != null ? _findUser(assignedTo!, users: users) : null,
      createdAt: DateTime.now(),
      userId: userId,
    );
  }

  static TaskStatus _parseStatus(String status) {
    switch (status) {
      case 'In Progress':
        return TaskStatus.inProgress;
      case 'Done':
        return TaskStatus.done;
      default:
        return TaskStatus.todo;
    }
  }

  static TaskPriority _parsePriority(String priority) {
    switch (priority) {
      case 'High':
        return TaskPriority.high;
      case 'Low':
        return TaskPriority.low;
      default:
        return TaskPriority.medium;
    }
  }

  static AppUser? _findUser(int userId , {List<AppUser> users = const []}) {
    final found = users.where((u) => u.id == userId.toString());
    return found.isNotEmpty ? found.first : null;
  }

  static TaskModel fromEntity(TaskEntity entity) {
    return TaskModel(
      id: int.tryParse(entity.id) ?? 0,
      title: entity.title,
      description: entity.description,
      status: _statusToString(entity.status),
      priority: _priorityToString(entity.priority),
      dueDate: entity.dueDate?.toIso8601String().split('T').first,
      assignedTo: entity.assignedUser != null
          ? int.tryParse(entity.assignedUser!.id)
          : null,
    );
  }

  static String _statusToString(TaskStatus s) {
    switch (s) {
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.done:
        return 'Done';
      default:
        return 'Todo';
    }
  }

  static String _priorityToString(TaskPriority p) {
    switch (p) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.low:
        return 'Low';
      default:
        return 'Medium';
    }
  }
}
