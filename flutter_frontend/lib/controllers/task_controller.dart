import '../models/task.dart';
import '../services/task_service.dart';


class TaskController {
  // Lọc task theo ngày hôm nay
  List<Task> filterTasksForToday(List<Task> tasks) {
    final now = DateTime.now();

    return tasks.where((task) =>
    task.deadline.year == now.year &&
        task.deadline.month == now.month &&
        task.deadline.day == now.day
    ).toList();
  }

  // Lấy task đầu tiên trong danh sách (ưu tiên deadline sớm nhất)
  Task? getFirstTaskOfToday(List<Task> tasks) {
    if (tasks.isEmpty) return null;

    tasks.sort((a, b) => a.deadline.compareTo(b.deadline));
    return tasks.first;
  }
}
