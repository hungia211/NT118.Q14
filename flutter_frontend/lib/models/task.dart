import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String userId;
  final String title;
  final String? description;

  /// not-started | in-progress | done | failed
  final String status;

  /// danh mục: work | study | health | relax | gardening | cook | meditation | other
  final String category;

  /// thời gian bắt đầu
  final DateTime startTime;

  /// thời lượng thực hiện
  final Duration duration;

  /// optional – chỉ dùng cho task kiểu deadline
  final DateTime? deadline;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.status,
    this.category = 'other', // giá trị mặc định
    required this.startTime,
    required this.duration,
    this.deadline,
  });

  // Chuyển Task -> Map để lưu Firestore
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'description': description};
  }

  /// thời gian kết thúc (tự suy ra)
  DateTime get endTime => startTime.add(duration);

  /// task đang diễn ra?
  bool get isInProgress {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  /// task bị trễ?
  bool get isFailed {
    final now = DateTime.now();
    return status != 'done' && now.isAfter(endTime);
  }

  Task copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? status,
    String? category,
    DateTime? startTime,
    Duration? duration,
    DateTime? deadline,
  }) {
    return Task(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      category: category ?? this.category,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
      deadline: deadline ?? this.deadline,
    );
  }

  // fromJson
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      userId: json['userId'],
      title: json['title'] ?? '',
      description: json['description'],
      status: json['status'] ?? 'not-started',
      category: json['category'] ?? 'other',

      startTime: (json['startTime'] as Timestamp).toDate(),

      duration: Duration(minutes: json['durationMinutes'] ?? 0),

      deadline: json['deadline'] != null
          ? (json['deadline'] as Timestamp).toDate()
          : null,
    );
  }


  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'status': status,
      'category': category,

      'startTime': Timestamp.fromDate(startTime),
      'durationMinutes': duration.inMinutes,
      'deadline': deadline != null
          ? Timestamp.fromDate(deadline!)
          : null,
    };
  }

}
