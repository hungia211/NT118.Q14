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
  /// XÓA TASK RÁC (title = "a")
  /// ================================
  // final oldTasks = await firestore
  //     .collection('tasks')
  //     .where('userId', isEqualTo: userId)
  //     .get();
  //
  // print('🧹 Found ${oldTasks.docs.length} old tasks');
  //
  // for (final doc in oldTasks.docs) {
  //   await doc.reference.delete();
  //   print('🗑 Deleted task: ${doc.id}');
  // }

  /// ================================
  /// TASKS THEO TỪNG NGÀY
  /// ================================
  final Map<int, List<Map<String, dynamic>>> tasksByDay = {
    /// ===== N-76: Ngày tập trung Fix bug & Refactor (Deep Work) =====
    -76: [
      task('Chạy bộ sáng', 'health', 'failed', // Lười quá không chạy
          date(now, -76, 6, 0), 45),
      task('Pha cà phê', 'cook', 'done',
          date(now, -76, 7, 0), 15),
      task('Check log lỗi server', 'work', 'failed', // Quá nhiều lỗi chưa xử lý
          date(now, -76, 7, 30), 60),
      task('Refactor module Auth', 'work', 'done',
          date(now, -76, 8, 45), 120),
      task('Họp team online', 'work', 'done',
          date(now, -76, 11, 0), 60),
      task('Nấu mì gói', 'cook', 'done', // Ăn nhanh để làm việc tiếp
          date(now, -76, 12, 15), 30),
      task('Chợp mắt', 'relax', 'done',
          date(now, -76, 13, 0), 20),
      task('Fix bug giao diện', 'work', 'failed', // Bug khó chưa fix được
          date(now, -76, 13, 30), 180),
      task('Tra cứu StackOverflow', 'study', 'done',
          date(now, -76, 16, 45), 45),
      task('Tưới cây ban công', 'gardening', 'failed', // Quên mất
          date(now, -76, 17, 45), 30),
      task('Order đồ ăn ngoài', 'other', 'done',
          date(now, -76, 19, 0), 30),
      task('Gaming giải tỏa', 'relax', 'done',
          date(now, -76, 20, 0), 120),
    ],

    /// ===== N-75: Ngày Chủ Nhật (Dọn dẹp & Reset) =====
    -75: [
      task('Ngủ nướng', 'relax', 'done',
          date(now, -75, 8, 30), 0), // Duration 0 hoặc tính từ đêm qua
      task('Ăn sáng muộn', 'cook', 'done',
          date(now, -75, 9, 0), 45),
      task('Giặt ủi quần áo', 'other', 'done',
          date(now, -75, 10, 0), 60),
      task('Dọn dẹp phòng', 'other', 'failed', // Lười quá bỏ qua
          date(now, -75, 11, 15), 90),
      task('Đi siêu thị tuần mới', 'other', 'failed', // Quên mất
          date(now, -75, 14, 0), 90),
      task('Sơ chế thức ăn', 'cook', 'done',
          date(now, -75, 16, 0), 60),
      task('Gọi điện cho mẹ', 'other', 'done',
          date(now, -75, 17, 30), 30),
      task('Chăm sóc cây cảnh', 'gardening', 'done',
          date(now, -75, 18, 15), 45),
      task('Ăn tối gia đình', 'cook', 'done',
          date(now, -75, 19, 30), 60),
      task('Lên plan tuần sau', 'study', 'done',
          date(now, -75, 21, 0), 45),
      task('Đắp mặt nạ/Skin care', 'health', 'done',
          date(now, -75, 22, 0), 30),
    ],

    /// ===== N-72: Ngày học công nghệ mới (Study Focus) =====
    -72: [
      task('Thiền định', 'meditation', 'done',
          date(now, -72, 6, 0), 20),
      task('Yoga giãn cơ', 'health', 'done',
          date(now, -72, 6, 30), 30),
      task('Ăn sáng healthy', 'cook', 'done',
          date(now, -72, 7, 15), 30),
      task('Học khóa học Udemy', 'study', 'done',
          date(now, -72, 8, 0), 120),
      task('Thực hành code mẫu', 'study', 'failed', // Quên làm bài tập
          date(now, -72, 10, 15), 90),
      task('Nấu ăn trưa', 'cook', 'done',
          date(now, -72, 12, 0), 45),
      task('Nghe Podcast Tech', 'relax', 'done',
          date(now, -72, 13, 0), 45),
      task('Viết bài blog', 'work', 'failed', // Bí ý tưởng
          date(now, -72, 14, 0), 90),
      task('Đọc sách chuyên ngành', 'study', 'done',
          date(now, -72, 16, 0), 60),
      task('Đi bơi', 'health', 'done',
          date(now, -72, 17, 30), 60),
      task('Ăn tối nhẹ', 'cook', 'done',
          date(now, -72, 19, 15), 30),
      task('Xem phim Netflix', 'relax', 'done',
          date(now, -72, 20, 0), 90),
      task('Ngủ sớm', 'meditation', 'done',
          date(now, -72, 22, 0), 15),
    ],
    /// ===== N-74: Ngày chạy Deadline (Work Hard) =====
    -74: [
      task('Dậy sớm check mail', 'work', 'done',
          date(now, -74, 5, 30), 30),
      task('Code tính năng Login', 'work', 'done',
          date(now, -74, 6, 0), 120),
      task('Ăn sáng nhanh', 'cook', 'done',
          date(now, -74, 8, 0), 15),
      task('Daily Meeting', 'work', 'failed', // Quên không tham gia
          date(now, -74, 8, 30), 60),
      task('Fix bug API', 'work', 'failed', // Bug khó chưa fix xong
          date(now, -74, 9, 45), 180),
      task('Ăn trưa văn phòng', 'other', 'done',
          date(now, -74, 12, 45), 45),
      task('Deploy lên Server Dev', 'work', 'done',
          date(now, -74, 14, 0), 60),
      task('Họp với Tester', 'work', 'done',
          date(now, -74, 15, 30), 90),
      task('OT (Làm thêm giờ)', 'work', 'done',
          date(now, -74, 17, 30), 120),
      task('Ăn tối muộn', 'cook', 'done',
          date(now, -74, 20, 0), 30),
      task('Ngủ bù', 'relax', 'done',
          date(now, -74, 21, 0), 0),
    ],

    /// ===== N-73: Ngày "Xả hơi" sau Deadline (Relax) =====
    -73: [
      task('Ngủ nướng', 'relax', 'done',
          date(now, -73, 9, 0), 0),
      task('Cà phê sáng', 'relax', 'done',
          date(now, -73, 9, 30), 60),
      task('Lướt Facebook/TikTok', 'relax', 'done',
          date(now, -73, 10, 30), 90),
      task('Ăn trưa với bạn', 'other', 'done',
          date(now, -73, 12, 0), 90),
      task('Đi xem phim', 'relax', 'done',
          date(now, -73, 14, 0), 150),
      task('Mua sắm', 'other', 'done',
          date(now, -73, 17, 0), 60),
      task('Chăm sóc da', 'health', 'done',
          date(now, -73, 20, 0), 45),
      task('Nghe nhạc Lo-fi', 'relax', 'done',
          date(now, -73, 21, 0), 60),
    ],

    /// ===== N-71: Ngày việc vặt gia đình (Family/Chores) =====
    -71: [
      task('Đi chợ sớm', 'cook', 'done',
          date(now, -71, 6, 30), 60),
      task('Nấu bữa sáng lớn', 'cook', 'done',
          date(now, -71, 7, 30), 60),
      task('Sửa vòi nước', 'other', 'failed', // Chưa sửa được
          date(now, -71, 9, 0), 45),
      task('Đưa mèo đi thú y', 'other', 'done',
          date(now, -71, 10, 0), 90),
      task('Dọn dẹp nhà bếp', 'other', 'done',
          date(now, -71, 14, 0), 60),
      task('Tưới cây sân thượng', 'gardening', 'done',
          date(now, -71, 16, 30), 45),
      task('Nấu lẩu gia đình', 'cook', 'done',
          date(now, -71, 18, 0), 120),
      task('Rửa bát', 'other', 'done',
          date(now, -71, 20, 30), 30),
    ],

    /// ===== N-70: Ngày ốm nhẹ (Health focus) =====
    -70: [
      task('Đo thân nhiệt', 'health', 'done',
          date(now, -70, 7, 0), 10),
      task('Uống thuốc', 'health', 'done',
          date(now, -70, 7, 15), 5),
      task('Nấu cháo', 'cook', 'done',
          date(now, -70, 7, 30), 45),
      task('Nghỉ ngơi', 'relax', 'done',
          date(now, -70, 8, 30), 120),
      task('Đọc sách nhẹ nhàng', 'study', 'done',
          date(now, -70, 14, 0), 60),
      task('Uống Vitamin', 'health', 'done',
          date(now, -70, 15, 30), 5),
      task('Yoga trị liệu', 'health', 'failed', // Mệt quá không tập nổi
          date(now, -70, 17, 0), 30),
      task('Ngủ sớm', 'health', 'done',
          date(now, -70, 20, 0), 0),
    ],

    /// ===== N-78: Ngày học kỹ năng mới (Self-Improvement) =====
    -78: [
      task('Chạy bộ công viên', 'health', 'done',
          date(now, -78, 5, 45), 45),
      task('Học từ vựng Tiếng Anh', 'study', 'done',
          date(now, -78, 7, 0), 45),
      task('Luyện nghe Podcast', 'study', 'done',
          date(now, -78, 8, 0), 30),
      task('Học Flutter Animation', 'study', 'done',
          date(now, -78, 9, 0), 120),
      task('Code thử UI mới', 'work', 'done',
          date(now, -78, 14, 0), 150),
      task('Đọc Medium', 'study', 'done',
          date(now, -78, 17, 0), 45),
      task('Viết nhật ký code', 'other', 'done',
          date(now, -78, 20, 0), 30),
      task('Thiền trước khi ngủ', 'meditation', 'done',
          date(now, -78, 22, 0), 15),
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
