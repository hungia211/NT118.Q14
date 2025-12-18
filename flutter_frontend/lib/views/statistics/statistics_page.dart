import 'package:flutter/material.dart';
import 'package:todo_app/views/home/home_page.dart';
import '../../services/task_service.dart';
import '../../services/statistics_service.dart';
import '../../controllers/statistics_controller.dart';
import '../../models/statistics.dart';
import '../../controllers/task_controller.dart';
import '../calendar/calendar_page.dart';
import '../tasks/task_list_page.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final taskService = TaskService();
  final statisticsService = StatisticsService();
  final controller = StatisticsController();
  final taskController = TaskController();

  late Future<StatisticsOverview> _future;
  String selectedPeriod = 'Tất cả';
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  final List<String> _periods = [
    'Tất cả',
    'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
    'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12',
  ];

  @override
  void initState() {
    super.initState();
    _future = _loadStatistics();
  }

  Future<StatisticsOverview> _loadStatistics() async {
    final tasks = await taskService.getTasks();
    return statisticsService.buildFromTasks(
      tasks,
      selectedMonth,
      selectedYear,
      period: selectedPeriod,
    );
  }

  void _onPeriodChanged(String? value) {
    if (value == null) return;

    setState(() {
      selectedPeriod = value;

      if (value == 'Tất cả') {
        // Không set month = 0
        selectedMonth = DateTime.now().month;
        selectedYear = DateTime.now().year;
      } else {
        // "Tháng 1" → 1, "Tháng 2" → 2 ...
        selectedMonth = _periods.indexOf(value);
        selectedYear = DateTime.now().year;
      }

      _future = _loadStatistics();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FEFB),

      // ================= BOTTOM NAVIGATION =================
      bottomNavigationBar: Container(
        height: 60 + MediaQuery.of(context).padding.bottom,
        padding: EdgeInsets.fromLTRB(
          10,
          20,
          10,
          0 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            // HOME
            Expanded(
              child: Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomePage(),
                      ),
                    );
                  },
                  child: const Icon(Icons.home, size: 30, color: Colors.black),
                ),
              ),
            ),


            // GRID
            Expanded(
              child: Center(
                child: InkWell(
                  onTap: () async {
                    final tasks = await taskService.getTasks();
                    final todayTasks = taskController.filterTasksForToday(tasks);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskListPage(tasks: todayTasks),
                      ),
                    );
                  },
                  child: const Icon(Icons.grid_view, size: 30, color: Colors.black),
                ),
              ),
            ),

            // BIG PLUS BUTTON
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 24, color: Colors.white),
                ),
              ),
            ),

            // CIRCLE ICON
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Icon(Icons.circle_outlined, color: Colors.green)),
                ),
              ),
            ),

            // CALENDAR
            Expanded(
              child: Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CalendarPage(),
                      ),
                    );
                  },
                  child: Center(child: Icon(Icons.calendar_today, size: 28, color: Colors.black)),
                ),
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: FutureBuilder<StatisticsOverview>(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Hiệu suất làm việc",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 40),
                  _buildCircularProgress(data.completionRate),
                  const SizedBox(height: 50),
                  _buildBars(data.dailyStats),
                  const SizedBox(height: 24),
                  _buildPeriodDropdown(),
                  const SizedBox(height: 32),
                  _buildCategorySection(data.categoryStats),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCircularProgress(double percent) {
    final value = (percent * 100).toInt();
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 16,
              strokeCap: StrokeCap.round,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade200),
            ),
          ),
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: percent,
              strokeWidth: 16,
              strokeCap: StrokeCap.round,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("$value%", style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50))),
              Text(
                "công việc đã hoàn thành",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBars(List<DailyStat> stats) {
    if (stats.isEmpty) return const Text("Chưa có dữ liệu");

    final months = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'];
    final colors = [
      const Color(0xFF5B7FFF), const Color(0xFFFFB74D), const Color(0xFFAB47BC),
      const Color(0xFF4CAF50), const Color(0xFF26C6DA), const Color(0xFFEC407A),
    ];

    final isAllTime = selectedPeriod == 'Tất cả';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(stats.length, (i) {
        final stat = stats[i];
        final height = (stat.completed.toDouble()).clamp(10.0, 100.0);
        final label = '${stat.date.day}/${stat.date.month}';

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: height,
              decoration: BoxDecoration(
                color: colors[i % colors.length],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 11,fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
          ],
        );
      }),
    );
  }

  Widget _buildPeriodDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF4CAF50), width: 1.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButton<String>(
        value: selectedPeriod,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF4CAF50)),
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        items: _periods.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
        onChanged: _onPeriodChanged,
      ),
    );
  }

  Widget _buildCategorySection(List<CategoryStat> categories) {
    if (categories.isEmpty) return const SizedBox();
    return Column(
      children: [
        const Text("Hoàn thành nhiều nhất", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...categories.map((cat) => _buildTaskRow(_getCategoryLabel(cat.category), cat.percent, _getCategoryColor(cat.category))),
      ],
    );
  }

  Widget _buildTaskRow(String title, int percent, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text(title, style: const TextStyle(fontSize: 14))),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 12,
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(6)),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percent / 100,
                child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6))),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 40, child: Text("$percent%", style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700, color: Colors.grey.shade600))),
        ],
      ),
    );
  }

  String _getCategoryLabel(String c) {
    switch (c) { case 'work': return 'Công việc'; case 'study': return 'Học tập'; case 'health': return 'Sức khỏe'; case 'relax': return 'Thư giãn'; case 'cook': return 'Nấu ăn'; case 'meditation': return 'Thiền'; default: return 'Khác'; }
  }

  Color _getCategoryColor(String c) {
    switch (c) { case 'work': return const Color(0xFF5B7FFF); case 'study': return const Color(0xFFFFB74D); case 'health': return const Color(0xFFEC407A); case 'relax': return const Color(0xFF26C6DA); default: return const Color(0xFF4CAF50); }
  }

}
