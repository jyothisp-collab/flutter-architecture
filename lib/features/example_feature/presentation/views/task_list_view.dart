import 'package:flutter/material.dart';
import 'package:flutter_architecture_showcase/features/example_feature/presentation/widgets/status_widget.dart';
import 'package:flutter_architecture_showcase/features/example_feature/presentation/viewmodels/task_viewmodel.dart';
import 'package:flutter_architecture_showcase/features/example_feature/presentation/widgets/task_item.dart';

class TaskListView extends StatelessWidget {
  final TaskViewModel viewModel;

  const TaskListView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks'), elevation: 2),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          final state = viewModel.state;
          return StatusWidget(
            isLoading: state is TaskLoading,
            errorMessage: state is TaskError ? state.message : null,
            child: state is TaskLoaded
                ? RefreshIndicator(
                    onRefresh: () => viewModel.loadTasks(),
                    child: ListView.builder(
                      itemCount: state.tasks.length,
                      itemBuilder: (context, index) {
                        final task = state.tasks[index];
                        return TaskItem(
                          task: task,
                          onToggle: () => viewModel.toggle(task.id),
                        );
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
