import 'package:flutter_architecture_showcase/features/example_feature/data/models/task_model.dart';

class TaskLocalDataSource {
  final List<TaskModel> initialTasks;
  final List<TaskModel> _tasks = [];

  TaskLocalDataSource({List<TaskModel>? initialTasks})
      : initialTasks = List.unmodifiable(initialTasks ?? const <TaskModel>[]) {
    if (initialTasks != null) _tasks.addAll(initialTasks);
  }

  Future<List<TaskModel>> getTasks() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_tasks);
  }

  Future<TaskModel?> toggleTask(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return null;
    final updated =
        _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted);
    _tasks[index] = updated;
    return updated;
  }
}
