import '../models/task.dart';

class TaskService {
  // Fake data
  final List<Task> _tasks = [
    Task(id: '1', title: 'Học code', description: 'Phải hoàn thành trước'),
    Task(id: '2', title: 'Chạy dl môn mobile'),
  ];

  List<Task> getTasks() {
    return _tasks;
  }

  void addTask(Task task) {
    _tasks.add(task);
  }
}
