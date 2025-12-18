class StatisticsOverview {
  final double completionRate;
  final List<DailyStat> dailyStats;
  final List<TaskUsageStat> mostUsedTasks;
  final List<CategoryStat> categoryStats; // THÊM MỚI

  StatisticsOverview({
    required this.completionRate,
    required this.dailyStats,
    required this.mostUsedTasks,
    required this.categoryStats,
  });
}

class DailyStat {
  final DateTime date;
  final int completed;

  DailyStat({required this.date, required this.completed});
}

class TaskUsageStat {
  final String title;
  final int percent;

  TaskUsageStat({required this.title, required this.percent});
}

// THÊM CLASS MỚI
class CategoryStat {
  final String category;
  final int count;
  final int percent;

  CategoryStat({
    required this.category,
    required this.count,
    required this.percent,
  });
}
