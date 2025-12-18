import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../controllers/statistics_controller.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../services/statistics_service.dart';
import '../../services/task_service.dart';
import '../home/home_page.dart';
import '../statistics/statistics_page.dart';
import '../tasks/task_list_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final taskService = TaskService();
  final statisticsService = StatisticsService();
  final controller = StatisticsController();
  final taskController = TaskController();

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<Task> _tasks = [];
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final allTasks = await taskService.getTasks();
    setState(() {
      _tasks = allTasks
          .where((t) =>
      t.startTime.year == _selectedDay.year &&
          t.startTime.month == _selectedDay.month &&
          t.startTime.day == _selectedDay.day)
          .toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _showAll = false;
    });
    _loadTasks();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'done':
        return const Color(0xFF4CAF50);
      case 'in-progress':
        return const Color(0xFFFFC107);
      case 'failed':
        return const Color(0xFFE57373);
      default:
        return const Color(0xFF90CAF9);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTasks = _showAll ? _tasks : _tasks.take(3).toList();

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
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StatisticsPage(),
                      ),
                    );
                  },
                  child: Center(child: Icon(Icons.circle_outlined, size: 30, color: Colors.black)),
                ),
              ),
            ),

            // CALENDAR
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Icon(Icons.calendar_today, color: Colors.green)),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ===== CALENDAR =====
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, color: Colors.white),
                            onSelected: (value) async {
                              if (value == 'pick_date') {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedDay,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030),
                                  locale: const Locale('vi', 'VN'),
                                );

                                if (pickedDate != null) {
                                  setState(() {
                                    _selectedDay = pickedDate;
                                    _focusedDay = pickedDate;
                                  });
                                  _loadTasks();
                                }
                              }
                            },
                            itemBuilder: (_) => [
                              const PopupMenuItem(
                                value: 'pick_date',
                                child: Text('Chọn ngày'),
                              ),
                            ],
                          ),


                        ],
                      ),
                    ),
                    TableCalendar(
                      locale: 'vi_VN',
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      onDaySelected: _onDaySelected,
                      calendarFormat: CalendarFormat.month,
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
                      ),
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(color: Colors.white70, fontSize: 12),
                        weekendStyle: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      calendarStyle: CalendarStyle(
                        defaultTextStyle: const TextStyle(color: Colors.white),
                        weekendTextStyle: const TextStyle(color: Colors.white),
                        outsideTextStyle: const TextStyle(color: Colors.white38),
                        todayDecoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: const TextStyle(
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // ===== SCHEDULE HEADER =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "My Schedule",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat("dd MMMM yyyy", "vi_VN").format(_selectedDay),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              // ===== TASK LIST =====
              if (_tasks.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Text(
                    "Không có công việc",
                    style: TextStyle(color: Colors.white54),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: displayTasks.length,
                  itemBuilder: (context, index) {
                    return _buildTaskItem(displayTasks[index]);
                  },
                ),

              // ===== VIEW ALL =====
              if (_tasks.length > 3 && !_showAll)
                TextButton(
                  onPressed: () => setState(() => _showAll = true),
                  child: const Text(
                    "View All",
                    style: TextStyle(color: Colors.black),
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    final timeStart = DateFormat('h:mm a').format(task.startTime);
    final timeEnd = DateFormat('h:mm a')
        .format(task.startTime.add(task.duration));
    final color = _getStatusColor(task.status);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TIMELINE
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 2,
              height: 60,
              color: color.withOpacity(0.4),
            ),
          ],
        ),
        const SizedBox(width: 12),

        // TASK CARD
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$timeStart - $timeEnd",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
