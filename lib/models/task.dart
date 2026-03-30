import 'package:hive/hive.dart';

part 'task.g.dart';

enum TaskStatus {
  todo,
  inProgress,
  done,
}

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String description;

  @HiveField(3)
  late DateTime dueDate;

  @HiveField(4)
  late TaskStatus status;

  @HiveField(5)
  late String? blockedBy; // ID of the task that blocks this one

  @HiveField(6)
  late DateTime createdAt;

  @HiveField(7)
  late DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.status = TaskStatus.todo,
    this.blockedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  String get statusString {
    switch (status) {
      case TaskStatus.todo:
        return 'To-Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.done:
        return 'Done';
    }
  }

  bool get isOverdue => dueDate.isBefore(DateTime.now()) && status != TaskStatus.done;

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskStatus? status,
    String? blockedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      blockedBy: blockedBy ?? this.blockedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
