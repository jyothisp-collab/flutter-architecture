import '../../domain/entities/task.dart';

class TaskModel {
  final String id;
  final String title;
  final bool isCompleted;

  const TaskModel(
      {required this.id, required this.title, required this.isCompleted});

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
        id: task.id, title: task.title, isCompleted: task.isCompleted);
  }

  Task toEntity() {
    return Task(id: id, title: title, isCompleted: isCompleted);
  }

  TaskModel copyWith({String? id, String? title, bool? isCompleted}) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
