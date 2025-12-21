// lib/views/tasks/add_task_page.dart
import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../calendar/calendar_page.dart';
import '../home/home_page.dart';
import '../statistics/statistics_page.dart';
import 'task_detail_page.dart';
import '../../controllers/task_controller.dart';
import '../../services/task_service.dart';
import 'task_list_page.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Thêm 2 dòng này
  final TaskService taskService = TaskService();
  final TaskController taskController = TaskController();

  String _selectedCategory = 'work';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _durationHours = 0;
  int _durationMinutes = 30;
  int _durationSeconds = 0;

  final List<String> _suggestions = [];
  bool _showSuggestions = false;

  final Map<String, Map<String, dynamic>> _categories = {
    'work': {'name': 'Công việc', 'image': 'assets/illus/meeting.png', 'color': Colors.blue},
    'study': {'name': 'Học tập', 'image': 'assets/illus/coding.png', 'color': Colors.orange},
    'health': {'name': 'Sức khỏe', 'image': 'assets/illus/workout.png', 'color': Colors.red},
    'relax': {'name': 'Thư giãn', 'image': 'assets/illus/relax.png', 'color': Colors.purple},
    'cook': {'name': 'Nấu ăn', 'image': 'assets/illus/cook.png', 'color': Colors.green},
    'gardening': {'name': 'Làm vườn', 'image': 'assets/illus/plant.png', 'color': Colors.teal},
    'meditation': {'name': 'Thiền', 'image': 'assets/illus/meditation.png', 'color': Colors.indigo},
    'other': {'name': 'Khác', 'image': 'assets/illus/default.png', 'color': Colors.grey},
  };

  final List<String> _allTasks = [
    'Viết code',
    'Họp nhóm',
    'Đọc sách',
    'Tập thể dục',
    'Nấu ăn',
    'Học Flutter',
    'Thiết kế UI',
    'Xem phim',
    'Nghỉ ngơi',
    'Làm bài tập',
  ];

  int _currentStep = 0;

  void _searchTasks(String query) {
    setState(() {
      if (query.isEmpty) {
        _suggestions.clear();
        _showSuggestions = false;
      } else {
        _suggestions.clear();
        _suggestions.addAll(
            _allTasks.where((task) =>
                task.toLowerCase().contains(query.toLowerCase())
            ).toList()
        );
        _showSuggestions = _suggestions.isNotEmpty;
      }
    });
  }

  void _goToNextStep() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tiêu đề công việc')),
      );
      return;
    }
    setState(() {
      _currentStep = 1;
    });
  }

  void _goToPreviousStep() {
    setState(() {
      _currentStep = 0;
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _createTask() {
    final startTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      status: 'not-started',
      category: _selectedCategory,
      startTime: startTime,
      duration: Duration(hours: _durationHours, minutes: _durationMinutes),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskDetailPage(task: newTask, isNewTask: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FEFB),
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
        child: _currentStep == 0 ? _buildTitleStep() : _buildDurationStep(),
      ),
    );
  }

  Widget _buildTitleStep() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios, color: Colors.green),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bạn sẽ làm gì?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _titleController,
                    onChanged: _searchTasks,
                    decoration: const InputDecoration(
                      hintText: 'Nhập công việc...',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),

                if (_showSuggestions)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: _suggestions.map((suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                          onTap: () {
                            _titleController.text = suggestion;
                            setState(() {
                              _showSuggestions = false;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                const SizedBox(height: 20),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Mô tả công việc...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Chọn danh mục:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),

                // Danh mục có thể lướt được
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final key = _categories.keys.elementAt(index);
                    final category = _categories[key]!;
                    final isSelected = _selectedCategory == key;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = key;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.green.shade100
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? Colors.green : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              category['image'] as String,
                              width: 50,
                              height: 50,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  _getCategoryIcon(key),
                                  size: 40,
                                  color: category['color'] as Color,
                                );
                              },
                            ),
                            const SizedBox(height: 6),
                            Text(
                              category['name'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // Bỏ _buildCategoryCard() ở đây

        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _goToNextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Tiếp theo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),


      ],
    );
  }

  Widget _buildDurationStep() {
    // Lấy tên tháng tiếng Việt
    const months = [
      "tháng 1", "tháng 2", "tháng 3", "tháng 4", "tháng 5", "tháng 6",
      "tháng 7", "tháng 8", "tháng 9", "tháng 10", "tháng 11", "tháng 12"
    ];
    const weekdays = [
      "Thứ Hai", "Thứ Ba", "Thứ Tư", "Thứ Năm", "Thứ Sáu", "Thứ Bảy", "Chủ Nhật"
    ];

    final weekdayName = weekdays[(_selectedDate.weekday - 1) % 7];
    final monthName = months[(_selectedDate.month - 1) % 12];

    // Chuyển đổi sang định dạng 12h
    int hour12 = _selectedTime.hourOfPeriod;
    if (hour12 == 0) hour12 = 12;
    String amPm = _selectedTime.period == DayPeriod.am ? 'AM' : 'PM';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              InkWell(
                onTap: _goToPreviousStep,
                child: const Icon(Icons.arrow_back_ios, color: Colors.green),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _selectDate,
                child: Column(
                  children: [
                    const Text(
                      'Hôm nay',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$weekdayName, ${_selectedDate.day} $monthName',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const SizedBox(width: 24),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const Text(
                  'Trong bao lâu?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDurationLabel('giờ'),
                    const SizedBox(width: 30),
                    _buildDurationLabel('phút'),
                    const SizedBox(width: 30),
                    _buildDurationLabel('giây'),
                  ],
                ),
                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLargeNumberPicker(_durationHours, 0, 23, (val) {
                      setState(() => _durationHours = val);
                    }),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(':', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    ),
                    _buildLargeNumberPicker(_durationMinutes, 0, 59, (val) {
                      setState(() => _durationMinutes = val);
                    }),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(':', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    ),
                    _buildLargeNumberPicker(_durationSeconds, 0, 59, (val) {
                      setState(() => _durationSeconds = val);
                    }),
                  ],
                ),

                const SizedBox(height: 30),

                const Text(
                  'Khi nào bắt đầu?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 15),

                GestureDetector(
                  onTap: _selectTime,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTimeBox(hour12.toString().padLeft(2, '0')),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(':', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      ),
                      _buildTimeBox(_selectedTime.minute.toString().padLeft(2, '0')),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(':', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      ),
                      _buildTimeBox(amPm),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        _buildCategoryCardWithTitle(),

        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _createTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Hoàn tất',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),


      ],
    );
  }

  Widget _buildDurationLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLargeNumberPicker(int value, int min, int max, Function(int) onChanged) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Center(
        child: DropdownButton<int>(
          value: value,
          underline: const SizedBox(),
          icon: const SizedBox(),
          items: List.generate(max - min + 1, (index) {
            return DropdownMenuItem(
              value: min + index,
              child: Text(
                (min + index).toString().padLeft(2, '0'),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            );
          }),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ),
    );
  }

  Widget _buildTimeBox(String value) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCardWithTitle() {
    final category = _categories[_selectedCategory]!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade400,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Text(
            _titleController.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Image.asset(
            category['image'] as String,
            width: 100,
            height: 100,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                _getCategoryIcon(_selectedCategory),
                size: 100,
                color: Colors.white,
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget _buildBottomNav() {
  //
  // }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'work':
        return Icons.computer;
      case 'study':
        return Icons.menu_book;
      case 'health':
        return Icons.fitness_center;
      case 'relax':
        return Icons.weekend;
      case 'cook':
        return Icons.restaurant;
      case 'gardening':
        return Icons.yard;
      case 'meditation':
        return Icons.self_improvement;
      case 'other':
        return Icons.task;
      default:
        return Icons.task;
    }
  }
}
