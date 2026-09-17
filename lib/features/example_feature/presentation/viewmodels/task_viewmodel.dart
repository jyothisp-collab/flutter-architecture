import 'package:flutter/foundation.dart';
import 'package:flutter_architecture_showcase/core/error/app_error.dart';
import 'package:flutter_architecture_showcase/features/example_feature/domain/entities/task.dart';
import 'package:flutter_architecture_showcase/features/example_feature/domain/usecases/get_tasks.dart';
import 'package:flutter_architecture_showcase/features/example_feature/domain/usecases/toggle_task.dart';

sealed class TaskState {
  const TaskState();
}

class TaskLoading extends TaskState {
  const TaskLoading();
}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  const TaskLoaded(this.tasks);
}

class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);
}

class TaskViewModel extends ChangeNotifier {
  final GetTasks getTasks;
  final ToggleTask toggleTask;

  TaskState _state = const TaskLoading();
  TaskState get state => _state;

  TaskViewModel({required this.getTasks, required this.toggleTask});

  Future<void> loadTasks() async {
    _setState(const TaskLoading());
    final result = await getTasks();
    result.match(
      onSuccess: (tasks) => _setState(TaskLoaded(tasks)),
      onFailure: (error) => _setState(TaskError(_mapError(error))),
    );
  }

  Future<void> toggle(String id) async {
    final result = await toggleTask(id);
    result.match(
      onSuccess: (_) => loadTasks(),
      onFailure: (error) => _setState(TaskError(_mapError(error))),
    );
  }

  void _setState(TaskState state) {
    _state = state;
    notifyListeners();
  }

  String _mapError(AppError error) => error.message;
}
