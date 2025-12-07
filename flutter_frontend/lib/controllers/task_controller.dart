import '../models/task.dart';
import '../services/task_service.dart';

class TaskController {
  final TaskService _service = TaskService();

  List<Task> get tasks => _service.getTasks();

  void addTask(String title) {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    );
    _service.addTask(newTask);
  }
}
