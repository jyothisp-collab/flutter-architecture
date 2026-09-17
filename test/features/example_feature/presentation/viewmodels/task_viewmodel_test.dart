import 'package:flutter_architecture_showcase/core/error/app_error.dart';
import 'package:flutter_architecture_showcase/core/error/result.dart';
import 'package:flutter_architecture_showcase/features/example_feature/domain/entities/task.dart';
import 'package:flutter_architecture_showcase/features/example_feature/domain/repositories/task_repository.dart';
import 'package:flutter_architecture_showcase/features/example_feature/domain/usecases/get_tasks.dart';
import 'package:flutter_architecture_showcase/features/example_feature/domain/usecases/toggle_task.dart';
import 'package:flutter_architecture_showcase/features/example_feature/presentation/viewmodels/task_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaskViewModel', () {
    test('loads tasks and transitions to loaded state', () async {
      final repo = _FakeRepo([
        Task(id: '1', title: 'Task A', isCompleted: false),
      ]);
      final viewModel = TaskViewModel(
        getTasks: GetTasks(repo),
        toggleTask: ToggleTask(repo),
      );

      expect(viewModel.state, isA<TaskLoading>());

      await viewModel.loadTasks();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(viewModel.state, isA<TaskLoaded>());
      final loaded = viewModel.state as TaskLoaded;
      expect(loaded.tasks.length, 1);
      expect(loaded.tasks[0].title, 'Task A');
    });

    test('propagates load error to error state', () async {
      final repo = _FailingRepo();
      final viewModel = TaskViewModel(
        getTasks: GetTasks(repo),
        toggleTask: ToggleTask(repo),
      );

      await viewModel.loadTasks();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(viewModel.state, isA<TaskError>());
    });

    test('toggles task and reloads list on success', () async {
      final repo = _FakeRepo([
        Task(id: '1', title: 'Task A', isCompleted: false),
      ]);
      final viewModel = TaskViewModel(
        getTasks: GetTasks(repo),
        toggleTask: ToggleTask(repo),
      );

      await viewModel.loadTasks();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(viewModel.state, isA<TaskLoaded>());

      await viewModel.toggle('1');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(viewModel.state, isA<TaskLoaded>());
      final loaded = viewModel.state as TaskLoaded;
      expect(loaded.tasks[0].isCompleted, isTrue);
    });

    test('propagates toggle error to error state', () async {
      final repo = _FailingRepo();
      final viewModel = TaskViewModel(
        getTasks: GetTasks(repo),
        toggleTask: ToggleTask(repo),
      );

      await viewModel.loadTasks();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await viewModel.toggle('1');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(viewModel.state, isA<TaskError>());
    });
  });
}

class _FakeRepo implements TaskRepository {
  final List<Task> _tasks;
  _FakeRepo(this._tasks);

  @override
  Future<Result<List<Task>>> getTasks() async =>
      Success(List.unmodifiable(_tasks));

  @override
  Future<Result<Task>> toggleTask(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    final updated =
        _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted);
    _tasks[index] = updated;
    return Success(updated);
  }
}

class _FailingRepo implements TaskRepository {
  @override
  Future<Result<List<Task>>> getTasks() async =>
      Failure(AppError('Simulated failure'));

  @override
  Future<Result<Task>> toggleTask(String id) async =>
      Failure(AppError('Simulated failure'));
}
