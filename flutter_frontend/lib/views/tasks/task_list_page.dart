import 'package:flutter/material.dart';
import '../../../models/task.dart';

class TaskListPage extends StatelessWidget {
  final List<Task>? tasks;

  const TaskListPage({super.key, this.tasks});

  @override
  Widget build(BuildContext context) {
    final list = tasks ?? []; // fallback nếu null

    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách công việc"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final task = list[index];
          return Card(
            child: ListTile(
              title: Text(task.title),
              subtitle: Text("${task.status} • ${task.deadline}"),
            ),
          );
        },
      ),
    );
  }
}
