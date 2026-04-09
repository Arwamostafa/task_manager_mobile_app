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

const List<AppUser> mockUsers = [
  AppUser(id: '1', name: 'Sara H.', initials: 'SH'),
  AppUser(id: '2', name: 'Ahmed M.', initials: 'AM'),
  AppUser(id: '3', name: 'Karim K.', initials: 'KK'),
  AppUser(id: '4', name: 'John D.', initials: 'JD'),
];

class TaskEntity {
  final String id;
  final String title;
  final String? description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueDate;
  final AppUser? assignedUser;
  final DateTime createdAt;

  const TaskEntity({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    this.assignedUser,
    required this.createdAt,
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
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      assignedUser:
          clearAssignedUser ? null : (assignedUser ?? this.assignedUser),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
