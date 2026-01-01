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

    await doc.set({...task.toFirestore(), 'id': doc.id});
  }

  // API Get Task List theo User ID
  Future<List<Task>> getTasksByUser(String userId) async {
    final snapshot = await _db
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      // ===== DEBUG LOG =====
      print('----- TASK DOC -----');
      print('id: ${doc.id}');
      print('title: ${data['title']}');
      print('status: ${data['status']}');
      print('startTime raw: ${data['startTime']}');
      print('duration raw: ${data['duration']}');
      print(
        'duration parsed: ${data['duration'] != null ? Duration(minutes: data['duration']) : Duration.zero}',
      );
      print('--------------------');

      final raw = data['duration'];
      print('duration raw: $raw, type: ${raw.runtimeType}');

      return Task(
        id: doc.id,
        userId: data['userId'],
        title: data['title'],
        description: data['description'],
        status: data['status'],
        category: data['category'] as String? ?? 'other',
        startTime: (data['startTime'] as Timestamp).toDate(),

        // duration lưu INT phút
        duration: data['durationMinutes'] != null
            ? Duration(minutes: data['durationMinutes'])
            : Duration.zero,

        deadline: data['deadline'] != null
            ? (data['deadline'] as Timestamp).toDate()
            : null,
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
