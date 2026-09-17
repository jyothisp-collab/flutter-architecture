import 'package:flutter_architecture_showcase/core/error/app_error.dart';
import 'package:flutter_architecture_showcase/core/error/result.dart';
import 'package:flutter_architecture_showcase/features/example_feature/data/datasources/task_local_data_source.dart';
import 'package:flutter_architecture_showcase/features/example_feature/domain/entities/task.dart';
import 'package:flutter_architecture_showcase/features/example_feature/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource dataSource;

  TaskRepositoryImpl(this.dataSource);

  @override
  Future<Result<List<Task>>> getTasks() async {
    try {
      final models = await dataSource.getTasks();
      return Success(models.map((m) => m.toEntity()).toList());
    } on Exception catch (e) {
      return Failure(AppError('Failed to load tasks: $e'));
    }
  }

  @override
  Future<Result<Task>> toggleTask(String id) async {
    try {
      final model = await dataSource.toggleTask(id);
      if (model == null) {
        return Failure(AppError('Task not found: $id'));
      }
      return Success(model.toEntity());
    } on Exception catch (e) {
      return Failure(AppError('Failed to toggle task: $e'));
    }
  }
}
