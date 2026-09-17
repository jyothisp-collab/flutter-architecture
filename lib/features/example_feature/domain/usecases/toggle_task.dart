import 'package:flutter_architecture_showcase/core/error/result.dart';
import 'package:flutter_architecture_showcase/features/example_feature/domain/entities/task.dart';
import 'package:flutter_architecture_showcase/features/example_feature/domain/repositories/task_repository.dart';

class ToggleTask {
  final TaskRepository repository;
  ToggleTask(this.repository);

  Future<Result<Task>> call(String id) => repository.toggleTask(id);
}
