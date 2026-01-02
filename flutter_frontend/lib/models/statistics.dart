class StatisticsOverview {
  /// % công việc hoàn thành (0.0 → 1.0)
  final double completionRate;

  /// Dữ liệu biểu đồ cột
  /// - Overview: theo THÁNG
  /// - Monthly: theo NGÀY
  final List<TimeStat> timeStats;

  /// (optional – dùng sau)
  final List<TaskUsageStat> mostUsedTasks;

  /// Thống kê theo category (CHỈ task DONE)
  final List<CategoryStat> categoryStats;

  StatisticsOverview({
    required this.completionRate,
    required this.timeStats,
    required this.mostUsedTasks,
    required this.categoryStats,
  });
}


class TimeStat {
  /// Ngày hoặc tháng (tuỳ filter)
  final DateTime date;

  /// % hoàn thành (0 → 100)
  final int percent;

  TimeStat({
    required this.date,
    required this.percent,
  });
}


class TaskUsageStat {
  final String title;
  final int percent;

  TaskUsageStat({
    required this.title,
    required this.percent,
  });
}

// THÊM CLASS MỚI
class CategoryStat {
  /// work | study | health | ...
  final String category;

  /// số task DONE
  final int count;

  /// % trên tổng task DONE
  final int percent;

  CategoryStat({
    required this.category,
    required this.count,
    required this.percent,
  });
}

