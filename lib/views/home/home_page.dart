import 'package:flutter/material.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TaskController controller = TaskController();

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = controller.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách công việc"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            leading: Icon(
              task.done ? Icons.check_circle : Icons.circle_outlined,
              color: task.done ? Colors.green : Colors.grey,
            ),
            title: Text(task.title),
            subtitle: task.description != null ? Text(task.description!) : null,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.addTask("New Task");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
