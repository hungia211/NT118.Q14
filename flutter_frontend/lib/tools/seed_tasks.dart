import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final firestore = FirebaseFirestore.instance;
  const userId = 'xXZ8wUdA8VMqxuNzXKZuOeLFJU42';

  final now = DateTime.now();

  print('🚀 START SEEDING TASKS');

  /// ================================
  /// 1️⃣ XÓA TASK RÁC (title = "a")
  /// ================================
  final oldTasks = await firestore
      .collection('tasks')
      .where('userId', isEqualTo: userId)
      .get();

  print('🧹 Found ${oldTasks.docs.length} old tasks');

  for (final doc in oldTasks.docs) {
    await doc.reference.delete();
    print('🗑 Deleted task: ${doc.id}');
  }

  /// ================================
  /// 2️⃣ TASKS THEO TỪNG NGÀY
  /// ================================
  final Map<int, List<Map<String, dynamic>>> tasksByDay = {
    /// ===== N-5: Ngày học tập nặng =====
    -5: [
      task('Thiền buổi sáng', 'meditation', 'done',
          date(now, -5, 6, 30), 15),
      task('Tập thể dục', 'health', 'done',
          date(now, -5, 6, 45), 30),
      task('Ăn sáng', 'cook', 'done',
          date(now, -5, 7, 30), 30),
      task('Học Flutter UI', 'study', 'done',
          date(now, -5, 8, 30), 90),
      task('Ôn bài', 'study', 'done',
          date(now, -5, 10, 15), 60),
      task('Nấu ăn trưa', 'cook', 'done',
          date(now, -5, 12, 0), 45),
      task('Nghỉ trưa', 'relax', 'done',
          date(now, -5, 13, 0), 30),
      task('Làm bài tập Mobile', 'study', 'done',
          date(now, -5, 14, 0), 120),
      task('Code demo UI', 'work', 'done',
          date(now, -5, 16, 15), 75),
      task('Tưới cây', 'gardening', 'done',
          date(now, -5, 17, 45), 30),
      task('Ăn tối', 'cook', 'done',
          date(now, -5, 19, 0), 45),
      task('Giải trí', 'relax', 'done',
          date(now, -5, 20, 0), 45),
      task('Nghỉ ngơi', 'meditation', 'done',
          date(now, -5, 21, 30), 15),
    ],

    /// ===== N-4: Ngày làm đồ án =====
    -4: [
      task('Tập thể dục', 'health', 'done',
          date(now, -4, 6, 15), 30),
      task('Ăn sáng', 'cook', 'done',
          date(now, -4, 7, 30), 30),
      task('Review yêu cầu đồ án', 'work', 'done',
          date(now, -4, 8, 30), 90),
      task('Thiết kế CSDL', 'work', 'done',
          date(now, -4, 10, 15), 75),
      task('Nấu ăn trưa', 'cook', 'done',
          date(now, -4, 12, 0), 45),
      task('Nghỉ trưa', 'relax', 'done',
          date(now, -4, 13, 0), 30),
      task('Code chức năng chính', 'work', 'done',
          date(now, -4, 14, 0), 150),
      task('Fix bug', 'work', 'done',
          date(now, -4, 16, 45), 60),
      task('Đi bộ nhẹ', 'health', 'done',
          date(now, -4, 18, 0), 30),
      task('Ăn tối', 'cook', 'done',
          date(now, -4, 19, 0), 45),
      task('Ghi chú tiến độ', 'other', 'done',
          date(now, -4, 20, 15), 30),
      task('Thư giãn', 'relax', 'done',
          date(now, -4, 21, 0), 45),
    ],

    /// ===== N-3: Ngày mệt (có failed) =====
    -3: [
      task('Ăn sáng', 'cook', 'done',
          date(now, -3, 7, 15), 30),
      task('Đọc tài liệu', 'study', 'done',
          date(now, -3, 8, 0), 90),
      task('Đi phỏng vấn', 'work', 'failed',
          date(now, -3, 10, 0), 90),
      task('Ăn trưa', 'cook', 'done',
          date(now, -3, 12, 30), 45),
      task('Nghỉ trưa', 'relax', 'done',
          date(now, -3, 13, 30), 30),
      task('Làm báo cáo thống kê', 'work', 'failed',
          date(now, -3, 14, 0), 120),
      task('Tập thể dục', 'health', 'done',
          date(now, -3, 15, 45), 30),
      task('Chăm cây', 'gardening', 'done',
          date(now, -3, 16, 30), 30),
      task('Đi bơi', 'health', 'failed',
          date(now, -3, 17, 30), 30),
      task('Nấu bữa tối', 'cook', 'failed',
          date(now, -3, 19, 0), 45),
      task('Xem phim', 'relax', 'done',
          date(now, -3, 20, 0), 90),
      task('Thiền nhẹ', 'meditation', 'failed',
          date(now, -3, 21, 45), 15),
    ],

    /// ===== N-2: Ngày cân bằng =====
    -2: [
      task('Tập thể dục', 'health', 'done',
          date(now, -4, 6, 30), 30),
      task('Yoga nhẹ', 'health', 'done',
          date(now, -2, 7, 0), 30),
      task('Ăn sáng', 'cook', 'done',
          date(now, -2, 8, 0), 30),
      task('Đọc paper', 'study', 'done',
          date(now, -2, 9, 0), 90),
      task('Nấu ăn trưa', 'cook', 'done',
          date(now, -2, 12, 0), 45),
      task('Nghỉ trưa', 'relax', 'done',
          date(now, -2, 13, 0), 30),
      task('Code statistics', 'work', 'failed',
          date(now, -2, 14, 30), 120),
      task('Review code', 'work', 'done',
          date(now, -2, 16, 45), 60),
      task('Ăn tối', 'cook', 'done',
          date(now, -2, 19, 0), 45),
      task('Nghe nhạc', 'relax', 'done',
          date(now, -2, 20, 0), 45),
      task('Việc cá nhân', 'other', 'done',
          date(now, -2, 21, 30), 30),
    ],

    /// ===== N-1: Chuẩn bị demo =====
    -1: [
      task('Tập thể dục', 'health', 'done',
          date(now, -4, 6, 45), 30),
      task('Ăn sáng', 'cook', 'done',
          date(now, -1, 7, 30), 30),
      task('Hoàn thiện UI', 'work', 'done',
          date(now, -1, 8, 30), 120),
      task('Test app', 'work', 'done',
          date(now, -1, 10, 45), 75),
      task('Ăn trưa', 'cook', 'done',
          date(now, -1, 12, 0), 45),
      task('Nghỉ trưa', 'relax', 'done',
          date(now, -1, 13, 0), 30),
      task('Seed dữ liệu demo', 'work', 'done',
          date(now, -1, 14, 0), 90),
      task('Chuẩn bị slide', 'study', 'done',
          date(now, -1, 15, 45), 90),
      task('Chạy bộ chiều', 'health', 'failed',
          date(now, -1, 15, 45), 90),
      task('Ăn tối', 'cook', 'done',
          date(now, -1, 19, 0), 45),
      task('Relax nhẹ', 'relax', 'done',
          date(now, -1, 20, 0), 45),
      task('Tổng kết ngày', 'relax', 'done',
          date(now, -1, 21, 30), 15),
    ],

    /// ===== N-0: Ngày demo =====
    0: [
      task('Tập thể dục', 'health', 'done',
          date(now, -4, 6, 00), 30),
      task('Ăn sáng', 'cook', 'done',
          date(now, 0, 7, 30), 30),
      task('Thuyết trình thử', 'study', 'done',
          date(now, 0, 8, 30), 120),
      task('Up code lên git', 'work', 'done',
          date(now, 0, 10, 45), 75),
      task('Đi siêu thị', 'cook', 'done',
          date(now, 0, 11, 0), 45),
      task('Nghỉ trưa', 'relax', 'done',
          date(now, 0, 12, 0), 30),
      task('Học tiếng anh', 'study', 'done',
          date(now, 0, 11, 0), 90),
      task('Demo app', 'study', 'done',
          date(now, 0, 15, 45), 90),
      task('Nấu ăn tối', 'cook', 'done',
          date(now, 0, 19, 0), 45),
      task('Thư giản nhẹ', 'relax', 'done',
          date(now, 0, 20, 0), 45),
      task('Xem phim', 'relax', 'done',
          date(now, 0, 21, 30), 15),
    ],
  };

  /// ================================
  /// 3️⃣ GHI FIRESTORE
  /// ================================
  for (final entry in tasksByDay.entries) {
    for (final task in entry.value) {
      await firestore.collection('tasks').add({
        'userId': userId,
        'title': task['title'],
        'category': task['category'],
        'status': task['status'],
        'startTime': Timestamp.fromDate(task['startTime']),
        'durationMinutes': task['durationMinutes'],
      });

      print('✅ Added: ${task['title']}');
    }
  }

  print('🎉 SEED COMPLETED');
}

/// ===== HELPER =====
Map<String, dynamic> task(
    String title,
    String category,
    String status,
    DateTime startTime,
    int durationMinutes,
    ) {
  return {
    'title': title,
    'category': category,
    'status': status,
    'startTime': startTime,
    'durationMinutes': durationMinutes,
  };
}

DateTime date(DateTime now, int dayOffset, int hour, int minute) {
  return DateTime(
    now.year,
    now.month,
    now.day + dayOffset,
    hour,
    minute,
  );
}
