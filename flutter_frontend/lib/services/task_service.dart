import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskService {
  final _db = FirebaseFirestore.instance;
  final _taskRef = FirebaseFirestore.instance.collection('tasks');

  // ============================================
  // PUBLIC FUNCTION — dùng để gọi ở Controller/UI
  // ============================================

  // API lấy danh sách tasks
  Future<List<Task>> getTasks() async {
    try {
      final querySnapshot = await _taskRef.get();
      final tasks = querySnapshot.docs
          .map((doc) => Task.fromJson(doc.data()))
          .toList();
      return tasks;
    } catch (e) {
      throw Exception("Error loading tasks from Firestore: $e");
    }
  }

  // API Add Task
  Future<void> addTask(Task task) async {
    final doc = _taskRef.doc();

    await doc.set({...task.toJson(), 'id': doc.id});
  }

  // API Get Task List theo User ID
  Future<List<Task>> getTasksByUser(String userId) async {
    final snapshot = await _db
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Task(
        id: doc.id,
        userId: data['userId'],
        title: data['title'],
        description: data['description'],
        status: data['status'],
        startTime: DateTime.parse(data['startTime']),
        duration: data['duration'] != null
            ? Duration(minutes: data['duration']) // lưu duration theo phút
            : Duration.zero, // hoặc Duration? nếu model nullable
      );
    }).toList();
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
