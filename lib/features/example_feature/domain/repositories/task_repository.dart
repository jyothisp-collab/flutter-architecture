import 'package:flutter_architecture_showcase/core/error/result.dart';
import 'package:flutter_architecture_showcase/features/example_feature/domain/entities/task.dart';

abstract class TaskRepository {
  Future<Result<List<Task>>> getTasks();
  Future<Result<Task>> toggleTask(String id);
}
