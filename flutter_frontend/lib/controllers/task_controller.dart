import '../models/task.dart';
import 'package:get/get.dart';
import '../services/task_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class TaskController extends GetxController {
  final TaskService _taskService = TaskService();
  // var isLoading = false.obs;

  final RxList<Task> tasks = <Task>[].obs;
  final RxBool isLoading = false.obs;

  final RxMap<String, double> dailyProgress = <String, double>{}.obs;

  // Add Task
  Future<void> addTask({
    required String title,
    String? description,
    required String category,
    required Duration duration,
    required DateTime startTime,
  }) async {
    if (title.trim().isEmpty) return;
    final user = FirebaseAuth.instance.currentUser;
    try {
      isLoading.value = true;

      final task = Task(
        id: '', // Firestore sẽ sinh id
        userId: user!.uid,
        title: title,
        description: description,
        status: 'todo', // mặc định
        category: category,
        startTime: startTime,
        duration: duration,
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

  /// Lấy tất cả task theo userId
  Future<void> loadTasksByUser(String userId) async {
    try {
      print('Loading tasks for userId: $userId'); // debug
      isLoading.value = true;
      final result = await _taskService.getTasksByUser(userId);
      print('Found ${result.length} tasks');
      tasks.assignAll(result);
      tasks.refresh();
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Xóa task
  Future<void> deleteTask(int index) async {
    final task = tasks[index];
    try {
      await _taskService.deleteTask(task.id); // xóa DB
      tasks.removeAt(index); // xóa local state
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể xóa công việc");
    }
  }

  // Chỉnh sửa Task
  Future<void> editTask(int index, Task updatedTask) async {
    try {
      await _taskService.updateTask(updatedTask); // update DB
      tasks[index] = updatedTask; // update local state
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể cập nhật công việc");
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

  // Thống kê theo ngày
  Future<void> loadDailyProgress(String userId) async {
    isLoading.value = true;

    final tasks = await _taskService.getTasksByUser(userId);

    final Map<String, List<Task>> groupByDate = {};

    for (final task in tasks) {
      final dateKey = DateFormat(
        'dd/MM',
      ).format(task.startTime); // group theo ngày

      groupByDate.putIfAbsent(dateKey, () => []);
      groupByDate[dateKey]!.add(task);
    }

    final Map<String, double> result = {};

    groupByDate.forEach((date, tasks) {
      final done = tasks.where((t) => t.status == 'done').length;
      result[date] = tasks.isEmpty ? 0 : done / tasks.length;
    });

    dailyProgress.value = result;
    isLoading.value = false;
  }
}
