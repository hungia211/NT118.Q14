class Task {
  final String id;
  final String title;
  final String? description;
  final String status; // "done", "in-progress", "not-started"
  final DateTime deadline;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.deadline,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    DateTime? deadline,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
    );
  }

  // ---------------------------
  // 🔹 fromJson (dùng cho Fake API & API thật)
  // ---------------------------
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'],
      status: json['status'] ?? 'not-started',
      deadline: DateTime.parse(json['deadline']),
    );
  }

  // ---------------------------
  // 🔹 toJson (dùng khi gửi lên API)
  // ---------------------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'deadline': deadline.toIso8601String(),
    };
  }
}
