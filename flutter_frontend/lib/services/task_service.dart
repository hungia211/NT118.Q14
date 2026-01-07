import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskService {
  final _db = FirebaseFirestore.instance;
  final _taskRef = FirebaseFirestore.instance.collection('tasks');

  // API lấy danh sách tasks
  Future<List<Task>> getTasks() async {
    try {
      final querySnapshot = await _taskRef.get();

      return querySnapshot.docs
          .map((doc) => Task.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception("Error loading tasks from Firestore: $e");
    }
  }

  // API Add Task
  Future<void> addTask(Task task) async {
    final doc = _taskRef.doc();
    await doc.set({
      ...task.toJson(),
      'id': doc.id,
    });
  }

  // API Get Task List theo User ID
  Future<List<Task>> getTasksByUser(String userId) async {
    final snapshot = await _db
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .orderBy('startTime', descending: false)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return Task(
        id: doc.id,
        userId: data['userId'],
        title: data['title'],
        description: data['description'],
        status: data['status'],
        category: data['category'] ?? 'other',
        startTime: (data['startTime'] as Timestamp).toDate(),
        duration: data['durationMinutes'] != null
            ? Duration(minutes: data['durationMinutes'])
            : Duration.zero,
      );
    }).toList();
  }

  // API Get Today's Tasks theo User ID
  Future<List<Task>> getTodayTasksByUser(String userId) async {
    final now = DateTime.now();

    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await _db
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .where(
      'startTime',
      isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
    )
        .where(
      'startTime',
      isLessThan: Timestamp.fromDate(endOfDay),
    )
        .orderBy('startTime', descending: false)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return Task(
        id: doc.id,
        userId: data['userId'],
        title: data['title'],
        description: data['description'],
        status: data['status'],
        category: data['category'] ?? 'other',
        startTime: (data['startTime'] as Timestamp).toDate(),
        duration: data['durationMinutes'] != null
            ? Duration(minutes: data['durationMinutes'])
            : Duration.zero,
      );
    }).toList();
  }

  // API Get Next Task theo User ID
  Future<Task?> getNextTaskForUser(String userId) async {
    final now = Timestamp.fromDate(DateTime.now());

    final snapshot = await _db
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .where('startTime', isGreaterThan: now)
        .orderBy('startTime', descending: false)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final doc = snapshot.docs.first;
    final data = doc.data();

    return Task(
      id: doc.id,
      userId: data['userId'],
      title: data['title'],
      description: data['description'],
      status: data['status'],
      category: data['category'] ?? 'other',
      startTime: (data['startTime'] as Timestamp).toDate(),
      duration: data['durationMinutes'] != null
          ? Duration(minutes: data['durationMinutes'])
          : Duration.zero,
    );
  }

  // API lấy danh sách title task (không trùng)
  Future<List<String>> getTaskTitlesByUser(String userId) async {
    final snapshot = await _db
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => doc.data()['title'] as String)
        .where((title) => title.trim().isNotEmpty)
        .toSet() // loại bỏ trùng
        .toList();
  }


  // API xóa task
  Future<void> deleteTask(String taskId) async {
    await _taskRef.doc(taskId).delete();
  }

  // Chỉnh sửa task
  Future<void> updateTask(Task task) async {
    await _taskRef.doc(task.id).update(task.toJson());
  }
}
