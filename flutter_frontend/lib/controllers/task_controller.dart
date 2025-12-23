import '../models/task.dart';
import 'package:get/get.dart';
import '../services/task_service.dart';

class TaskController extends GetxController {
  final TaskService _taskService = TaskService();
  var isLoading = false.obs;

  Future<void> addTask({required String title, String? description}) async {
    if (title.trim().isEmpty) return;

    try {
      isLoading.value = true;

      final task = Task(
        id: '', // Firestore sẽ sinh id
        title: title,
        description: description,
        status: 'todo', // mặc định
        startTime: DateTime.now(),
        duration: const Duration(minutes: 30),
      );

      await _taskService.addTask(task);

      Get.back();
      Get.snackbar('Success', 'Task added');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Lấy tất cả task của hôm nay
  List<Task> filterTasksForToday(List<Task> tasks) {
    final now = DateTime.now();

    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return tasks.where((task) {
      // Task bắt đầu trong hôm nay
      final startsToday =
          task.startTime.isAfter(startOfDay) &&
          task.startTime.isBefore(endOfDay);

      // Task bắt đầu hôm trước nhưng kéo dài sang hôm nay
      final overlapsToday =
          task.startTime.isBefore(endOfDay) && task.endTime.isAfter(startOfDay);

      return startsToday || overlapsToday;
    }).toList();
  }

  /// Task sắp diễn ra nhất (upcoming)
  Task? getNextTask(List<Task> tasks) {
    final now = DateTime.now();

    final upcomingTasks = tasks
        .where((task) => task.startTime.isAfter(now))
        .toList();

    if (upcomingTasks.isEmpty) return null;

    upcomingTasks.sort((a, b) => a.startTime.compareTo(b.startTime));
    return upcomingTasks.first;
  }

  /// Task đang diễn ra
  Task? getCurrentTask(List<Task> tasks) {
    final now = DateTime.now();

    try {
      return tasks.firstWhere(
        (task) => now.isAfter(task.startTime) && now.isBefore(task.endTime),
      );
    } catch (_) {
      return null;
    }
  }

  /// Cập nhật status tự động theo thời gian
  List<Task> autoUpdateStatus(List<Task> tasks) {
    final now = DateTime.now();

    return tasks.map((task) {
      // Nếu đã done → không động
      if (task.status == 'done') return task;

      // Chưa tới giờ
      if (now.isBefore(task.startTime)) {
        return task.copyWith(status: 'not-started');
      }

      // Đang làm
      if (now.isAfter(task.startTime) && now.isBefore(task.endTime)) {
        return task.copyWith(status: 'in-progress');
      }

      // Quá giờ mà chưa xong
      if (now.isAfter(task.endTime)) {
        return task.copyWith(status: 'failed');
      }

      return task;
    }).toList();
  }
}
