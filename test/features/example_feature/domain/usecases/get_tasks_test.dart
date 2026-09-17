import 'package:flutter_architecture_showcase/core/error/result.dart';
import 'package:flutter_architecture_showcase/features/example_feature/domain/entities/task.dart';
import 'package:flutter_architecture_showcase/features/example_feature/domain/repositories/task_repository.dart';
import 'package:flutter_architecture_showcase/features/example_feature/domain/usecases/get_tasks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GetTasks', () {
    test('returns tasks from repository', () async {
      final repo = _FakeRepo([
        Task(id: '1', title: 'Test', isCompleted: false),
      ]);
      final result = await GetTasks(repo)();

      expect(result, isA<Success<List<Task>>>());
      final tasks = (result as Success<List<Task>>).data;
      expect(tasks.length, 1);
      expect(tasks[0].title, 'Test');
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
    final task = _tasks.firstWhere((t) => t.id == id);
    return Success(task.copyWith(isCompleted: !task.isCompleted));
  }
}
