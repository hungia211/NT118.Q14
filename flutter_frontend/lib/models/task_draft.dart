class TaskDraft {
  String title;
  String category;
  DateTime startTime;
  int durationMinutes;

  TaskDraft({
    required this.title,
    required this.category,
    required this.startTime,
    required this.durationMinutes,
  });

  factory TaskDraft.fromJson(Map<String, dynamic> json) {
    return TaskDraft(
      title: json['title'],
      category: json['category'],
      startTime: _parseTime(json['startTime']),
      durationMinutes: json['durationMinutes'],
    );
  }

  static DateTime _parseTime(String timeStr) {
    if (RegExp(r'^\d{1,2}:\d{2}$').hasMatch(timeStr)) {
      final parts = timeStr.split(':');
      final now = DateTime.now();
      final tomorrow = now.add(const Duration(days: 1));
      return DateTime(
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    }
    return DateTime.parse(timeStr);
  }
}
