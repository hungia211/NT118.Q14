import '../models/task.dart';
import '../models/statistics.dart';

class StatisticsService {
  StatisticsOverview buildFromTasks(
      List<Task> tasks,
      int month,
      int year, {
        String period = 'All time',
      }) {
    final now = DateTime.now();
    List<Task> filteredTasks;
    List<DailyStat> dailyStats = [];

    if (period == 'All time') {
      // Vòng tròn: % hoàn thành tất cả task
      filteredTasks = tasks;

      // Cột: % hoàn thành từng tháng (6 tháng gần nhất)
      final Map<String, int> monthlyDone = {};
      final Map<String, int> monthlyTotal = {};

      for (final t in tasks) {
        final key = '${t.startTime.year}-${t.startTime.month}';
        monthlyTotal[key] = (monthlyTotal[key] ?? 0) + 1;
        if (t.status == 'done') {
          monthlyDone[key] = (monthlyDone[key] ?? 0) + 1;
        }
      }

      for (int i = 5; i >= 0; i--) {
        final targetDate = DateTime(now.year, now.month - i, 1);
        final key = '${targetDate.year}-${targetDate.month}';
        final done = monthlyDone[key] ?? 0;
        final total = monthlyTotal[key] ?? 0;
        final percent = total == 0 ? 0 : ((done / total) * 100).round();
        dailyStats.add(DailyStat(date: targetDate, completed: percent));
      }
    } else {
      // Chọn tháng cụ thể
      filteredTasks = tasks.where((t) =>
      t.startTime.month == month && t.startTime.year == year).toList();

      // Cột: % hoàn thành từng ngày trong tháng (6 ngày gần nhất có dữ liệu hoặc từ ngày hiện tại)
      final Map<String, int> dailyDone = {};
      final Map<String, int> dailyTotal = {};

      for (final t in filteredTasks) {
        final key = '${t.startTime.year}-${t.startTime.month}-${t.startTime.day}';
        dailyTotal[key] = (dailyTotal[key] ?? 0) + 1;
        if (t.status == 'done') {
          dailyDone[key] = (dailyDone[key] ?? 0) + 1;
        }
      }

      // Lấy 6 ngày gần nhất trong tháng được chọn
      final baseDate = (month == now.month && year == now.year)
          ? now
          : DateTime(year, month + 1, 0); // Ngày cuối tháng

      for (int i = 5; i >= 0; i--) {
        final targetDate = baseDate.subtract(Duration(days: i));
        if (targetDate.month != month || targetDate.year != year) continue;

        final key = '${targetDate.year}-${targetDate.month}-${targetDate.day}';
        final done = dailyDone[key] ?? 0;
        final total = dailyTotal[key] ?? 0;
        final percent = total == 0 ? 0 : ((done / total) * 100).round();
        dailyStats.add(DailyStat(date: targetDate, completed: percent));
      }
    }

    // ===== COMPLETION RATE =====
    final doneTasks = filteredTasks.where((t) => t.status == 'done').length;
    final completionRate =
    filteredTasks.isEmpty ? 0.0 : doneTasks / filteredTasks.length;

    // ===== CATEGORY STATS (chỉ tính task hoàn thành) =====
    final completedTasks = filteredTasks.where((t) => t.status == 'done').toList();
    final Map<String, int> categoryCount = {};
    for (final t in completedTasks) {
      categoryCount[t.category] = (categoryCount[t.category] ?? 0) + 1;
    }

    final int totalCompleted = completedTasks.length;
    final List<CategoryStat> categoryStats = totalCompleted == 0
        ? []
        : categoryCount.entries.map((e) {
      return CategoryStat(
        category: e.key,
        count: e.value,
        percent: ((e.value / totalCompleted) * 100).round(),
      );
    }).toList()
      ..sort((a, b) => b.count.compareTo(a.count));

    return StatisticsOverview(
      completionRate: completionRate,
      dailyStats: dailyStats,
      mostUsedTasks: [],
      categoryStats: categoryStats,
    );
  }
}
