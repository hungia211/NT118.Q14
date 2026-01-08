import 'package:flutter/cupertino.dart';

import '../models/app_notification.dart';
import '../models/task.dart';
import 'package:get/get.dart';
import '../models/task_draft.dart';
import '../services/ai_suggestion_service.dart';
import '../services/notification_service.dart';
import '../services/task_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'notification_controller.dart';

class TaskController extends GetxController {
  final TaskService _taskService = TaskService();
  // var isLoading = false.obs;

  final RxList<Task> tasks = <Task>[].obs;
  final RxBool isLoading = false.obs;
  final Rxn<Task> nextTask = Rxn<Task>();

  // Danh sách gợi ý title cho AddTask
  final RxList<String> taskTitleSuggestions = <String>[].obs;
  final RxBool isLoadingTitleSuggestions = false.obs;
  final RxBool hasUnreadNotification = false.obs;
  final NotificationController notiController =
      Get.find<NotificationController>();

  final RxDouble todayProgress = 0.0.obs;

  final AiSuggestionService _aiService = AiSuggestionService();


  // Sắp xếp tasks theo startTime
  void _sortTasksByStartTime() {
    tasks.sort((a, b) => a.startTime.compareTo(b.startTime));
  }

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
        status: 'not-started', // mặc định
        category: category,
        startTime: startTime,
        duration: duration,
      );

      await _taskService.addTask(task);

      final now = DateTime.now();

      if (task.startTime.isAfter(now)) {
        final notificationId = task.id.hashCode;

        await NotificationService.scheduleTaskNotification(
          id: notificationId,
          title: 'Đến giờ rồi!',
          body: task.title,
          scheduledTime: task.startTime,
        );
      } else {
        debugPrint('⚠️ Không schedule notification vì startTime đã qua');
      }

      Get.back();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Lấy tất cả task theo userId
  Future<void> loadTasksByUser(String userId) async {
    try {
      isLoading.value = true;

      final result = await _taskService.getTasksByUser(userId);

      tasks.assignAll(result);
      _sortTasksByStartTime();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Lấy task hôm nay theo userId
  Future<void> loadTodayTasks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      isLoading.value = true;
      final result = await _taskService.getTodayTasksByUser(user.uid);
      tasks.assignAll(result);
      _sortTasksByStartTime();
      updateTodayProgress();
      for (final task in result) {
        if (task.startTime.isAfter(DateTime.now())) {
          final id = task.startTime.millisecondsSinceEpoch.remainder(100000);

          await NotificationService.scheduleTaskNotification(
            id: id,
            title: 'Đến giờ rồi!',
            body: task.title,
            scheduledTime: task.startTime,
          );

          if (!notiController.notifications.any((n) => n.id == task.id)) {
            notiController.addNotification(
              AppNotification(
                id: task.id,
                title: 'Đến giờ rồi!',
                message: task.title,
                time: task.startTime,
              ),
            );
          }
        }
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Lấy task sắp diễn ra nhất cho Home Page
  Future<void> loadNextTaskForHome() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final task = await _taskService.getNextTaskForUser(user.uid);
      nextTask.value = task; // có thể null
      updateTodayProgress();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  /// Tính tiến độ công việc hôm nay (0.00 → 1.00)
  double calculateTodayProgress() {
    final todayTasks = filterTasksForToday(tasks);

    if (todayTasks.isEmpty) return 0.0;

    final completedCount = todayTasks
        .where((task) => task.status == 'done')
        .length;

    final progress = completedCount / todayTasks.length;

    // làm tròn 2 chữ số thập phân~
    return double.parse(progress.toStringAsFixed(2));
  }

  // Xóa task
  Future<void> deleteTask(int index) async {
    final task = tasks[index];
    try {
      await _taskService.deleteTask(task.id); // xóa DB
      tasks.removeAt(index);
      _sortTasksByStartTime();
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể xóa công việc");
    }
  }

  // Chỉnh sửa Task
  Future<void> editTask(int index, Task updatedTask) async {
    try {
      await _taskService.updateTask(updatedTask); // update DB
      tasks[index] = updatedTask; // update local state
      _sortTasksByStartTime();
      tasks.refresh();
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

  // Lấy gợi ý title cho Add Task
  Future<void> loadTaskTitleSuggestions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      isLoadingTitleSuggestions.value = true;

      final titles = await _taskService.getTaskTitlesByUser(user.uid);

      taskTitleSuggestions.assignAll(titles);
    } catch (e) {
      Get.snackbar('Error', 'Không thể tải gợi ý công việc');
    } finally {
      isLoadingTitleSuggestions.value = false;
    }
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

  // Cập nhật tiến độ công việc hôm nay
  void updateTodayProgress() {
    final todayTasks = filterTasksForToday(tasks);

    if (todayTasks.isEmpty) {
      todayProgress.value = 0.0;
      return;
    }

    final completed = todayTasks.where((task) => task.status == 'done').length;

    todayProgress.value = double.parse(
      (completed / todayTasks.length).toStringAsFixed(2),
    );
  }

  // Xây dựng prompt từ lịch sử task 5 ngày gần nhất
  Future<String> buildPromptFromLast5Days() async {
    final user = FirebaseAuth.instance.currentUser!;
    // Giả sử bạn lấy được tasks
    final tasks = await _taskService.getTasksByUser(user.uid);

    final now = DateTime.now();
    final fiveDaysAgo = now.subtract(const Duration(days: 5));

    final recentTasks = tasks
        .where((t) => t.startTime.isAfter(fiveDaysAgo))
        .toList();

    final buffer = StringBuffer();

    // 1. CUNG CẤP NGÀY HIỆN TẠI (Quan trọng)
    buffer.writeln('Today represents: ${now.toIso8601String()}.');
    buffer.writeln('You are an AI assistant that helps plan daily tasks for a Vietnamese student.');
    buffer.writeln('Here is the task history of the last 5 days to understand user habits:');

    for (final t in recentTasks) {
      // Chỉ cần gửi giờ, không cần gửi phút chi tiết nếu không cần thiết để tiết kiệm token
      buffer.writeln(
        '- ${t.title} [${t.category}]: ${t.startTime.hour}:${t.startTime.minute.toString().padLeft(2, '0')}, duration: ${t.duration.inMinutes}m',
      );
    }

    buffer.writeln('''
      Suggest a task plan for TOMORROW.
      
      IMPORTANT RULES:
      1. Task titles MUST be written in Vietnamese.
      2. Categories MUST be one of: work, study, health, relax, gardening, cook, meditation, other.
      3. Return ONLY a valid JSON array.
      4. "startTime" must be in "HH:mm" format (24-hour clock). DO NOT return full date.
      
      JSON format example:
      [
        {
          "title": "Ôn tập lập trình Mobile",
          "category": "study",
          "startTime": "08:00", 
          "durationMinutes": 60
        }
      ]
    ''');

    return buffer.toString();
  }

  Future<List<TaskDraft>> generateAiTasks() async {
    try {
      final prompt = await buildPromptFromLast5Days();
      final drafts = await _aiService.suggestTasks(prompt);
      drafts.sort((a, b) => a.startTime.compareTo(b.startTime));
      return drafts;
    } catch (e) {
      rethrow;
    }
  }
}
