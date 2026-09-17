import 'package:flutter_architecture_showcase/core/error/result.dart';
import 'package:flutter_architecture_showcase/features/example_feature/domain/entities/task.dart';
import 'package:flutter_architecture_showcase/features/example_feature/domain/repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;
  GetTasks(this.repository);

  Future<Result<List<Task>>> call() => repository.getTasks();
}
