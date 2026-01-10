import '../models/task.dart';
import '../models/statistics.dart';

class StatisticsService {
  StatisticsOverview buildStatistics({
    required List<Task> tasks,
    required bool isAllTime,
    int? month,
    int? year,
  }) {
    final now = DateTime.now();

    // ================= FILTER TASKS =================
    final filteredTasks = isAllTime
        ? tasks
        : tasks.where((t) =>
    t.startTime.month == month &&
        t.startTime.year == year,
    ).toList();

    // ================= COMPLETION RATE =================
    final doneCount =
        filteredTasks.where((t) => t.status == 'done').length;

    final completionRate = filteredTasks.isEmpty
        ? 0.0
        : doneCount / filteredTasks.length;

    // ================= CATEGORY STATS (ĐÚNG LOGIC) =================
    final Map<String, int> categoryTotal = {};
    final Map<String, int> categoryDone = {};

    for (final t in filteredTasks) {
      // tổng task của category
      categoryTotal[t.category] =
          (categoryTotal[t.category] ?? 0) + 1;

      // task hoàn thành của category
      if (t.status == 'done') {
        categoryDone[t.category] =
            (categoryDone[t.category] ?? 0) + 1;
      }
    }

    final List<CategoryStat> categoryStats =
    categoryTotal.entries.map((e) {
      final category = e.key;
      final total = e.value;
      final done = categoryDone[category] ?? 0;

      final percent =
      total == 0 ? 0 : ((done / total) * 100).round();

      return CategoryStat(
        category: category,
        count: done,        // số task đã hoàn thành
        percent: percent,   // % hoàn thành của category đó
      );
    }).toList()
      ..sort((a, b) => b.percent.compareTo(a.percent));

    // ================= BAR CHART DATA =================
    final List<TimeStat> timeStats = [];

    if (isAllTime) {
      // ===== MONTHLY STATS (6 tháng gần nhất)
      for (int i = 5; i >= 0; i--) {
        final d = DateTime(now.year, now.month - i, 1);

        final monthTasks = tasks.where((t) =>
        t.startTime.month == d.month &&
            t.startTime.year == d.year,
        );

        final total = monthTasks.length;
        final done =
            monthTasks.where((t) => t.status == 'done').length;

        timeStats.add(
          TimeStat(
            date: d,
            percent:
            total == 0 ? 0 : ((done / total) * 100).round(),
          ),
        );
      }
    } else {
      // ===== DAILY STATS IN MONTH
      final lastDay = DateTime(year!, month! + 1, 0).day;

      for (int day = 1; day <= lastDay; day++) {
        final d = DateTime(year, month, day);

        final dayTasks = filteredTasks.where(
              (t) => t.startTime.day == day,
        );

        final total = dayTasks.length;
        final done =
            dayTasks.where((t) => t.status == 'done').length;

        if (total > 0) {
          timeStats.add(
            TimeStat(
              date: d,
              percent: ((done / total) * 100).round(),
            ),
          );
        }
      }
    }

    return StatisticsOverview(
      completionRate: completionRate,
      timeStats: timeStats,
      mostUsedTasks: const [],
      categoryStats: categoryStats,
    );
  }
}
