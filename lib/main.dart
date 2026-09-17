import 'package:flutter/material.dart';
import 'package:flutter_architecture_showcase/features/example_feature/data/datasources/task_local_data_source.dart';
import 'package:flutter_architecture_showcase/features/example_feature/data/models/task_model.dart';
import 'package:flutter_architecture_showcase/features/example_feature/data/repositories/task_repository_impl.dart';
import 'package:flutter_architecture_showcase/features/example_feature/domain/usecases/get_tasks.dart';
import 'package:flutter_architecture_showcase/features/example_feature/domain/usecases/toggle_task.dart';
import 'package:flutter_architecture_showcase/features/example_feature/presentation/viewmodels/task_viewmodel.dart';
import 'package:flutter_architecture_showcase/features/example_feature/presentation/views/task_list_view.dart';

void main() {
  final dataSource = TaskLocalDataSource(
    initialTasks: [
      TaskModel(
          id: '1', title: 'Review architecture layers', isCompleted: true),
      TaskModel(id: '2', title: 'Define domain entities', isCompleted: true),
      TaskModel(
          id: '3', title: 'Implement repository pattern', isCompleted: false),
      TaskModel(id: '4', title: 'Write unit tests', isCompleted: false),
      TaskModel(
          id: '5', title: 'Document design decisions', isCompleted: false),
    ],
  );

  final repository = TaskRepositoryImpl(dataSource);

  runApp(
    _App(
      viewModel: TaskViewModel(
        getTasks: GetTasks(repository),
        toggleTask: ToggleTask(repository),
      ),
    ),
  );
}

class _App extends StatelessWidget {
  final TaskViewModel viewModel;

  const _App({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Architecture Showcase',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: TaskListView(viewModel: viewModel),
    );
  }
}
