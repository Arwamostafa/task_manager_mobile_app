
enum TaskStatus { todo, inProgress, done }

enum TaskPriority { low, medium, high }

class AppUser {
  final String id;
  final String name;
  final String initials;

  const AppUser({
    required this.id,
    required this.name,
    required this.initials,
  });
}

class TaskEntity {
  final String id;
  final String title;
  final String? description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueDate;
  final AppUser? assignedUser;
  final DateTime createdAt;
  final int? userId; 

  const TaskEntity({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    this.assignedUser,
    required this.createdAt,
    this.userId, 
  });

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueDate,
    AppUser? assignedUser,
    bool clearDueDate = false,
    bool clearAssignedUser = false,
    DateTime? createdAt,
    int? userId,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      assignedUser:clearAssignedUser ? null : (assignedUser ?? this.assignedUser),
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }
}
