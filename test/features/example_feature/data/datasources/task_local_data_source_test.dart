import 'package:flutter_architecture_showcase/features/example_feature/data/datasources/task_local_data_source.dart';
import 'package:flutter_architecture_showcase/features/example_feature/data/models/task_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaskLocalDataSource', () {
    test('returns initial tasks', () async {
      final source = TaskLocalDataSource(
        initialTasks: [TaskModel(id: '1', title: 'Item', isCompleted: false)],
      );

      final tasks = await source.getTasks();
      expect(tasks.length, 1);
      expect(tasks[0].title, 'Item');
    });

    test('toggleTask updates and returns the task', () async {
      final source = TaskLocalDataSource(
        initialTasks: [TaskModel(id: '1', title: 'Item', isCompleted: false)],
      );

      final result = await source.toggleTask('1');
      expect(result, isNotNull);
      expect(result!.isCompleted, isTrue);

      final updated = await source.getTasks();
      expect(updated[0].isCompleted, isTrue);
    });
  });
}
