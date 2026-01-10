// lib/views/tasks/task_detail_page.dart
import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../home/home_page.dart';
import '../../controllers/task_controller.dart';
import 'package:get/get.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;
  final bool isNewTask;

  const TaskDetailPage({super.key, required this.task, this.isNewTask = false});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _selectedCategory;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late int _durationMinutes;
  bool _isEditing = false;

  // Hàm format giờ 12h với AM/PM
  String _formatTime12h(TimeOfDay time) {
    final int hour12 = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final String minute = time.minute.toString().padLeft(2, '0');
    final String amPm = time.hour >= 12 ? 'PM' : 'AM';
    return '${hour12.toString().padLeft(2, '0')}:$minute $amPm';
  }

  // Khai báo controller GetX
  final TaskController taskController = Get.find<TaskController>();


  final Map<String, Map<String, dynamic>> _categories = {
    'work': {
      'name': 'Công việc',
      'image': 'assets/illus/meeting.png',
      'color': Colors.blue,
    },
    'study': {
      'name': 'Học tập',
      'image': 'assets/illus/coding.png',
      'color': Colors.orange,
    },
    'health': {
      'name': 'Sức khỏe',
      'image': 'assets/illus/workout.png',
      'color': Colors.red,
    },
    'relax': {
      'name': 'Thư giãn',
      'image': 'assets/illus/relax.png',
      'color': Colors.purple,
    },
    'cook': {
      'name': 'Nấu ăn',
      'image': 'assets/illus/cook.png',
      'color': Colors.green,
    },
    'gardening': {
      'name': 'Làm vườn',
      'image': 'assets/illus/plant.png',
      'color': Colors.teal,
    },
    'meditation': {
      'name': 'Thiền',
      'image': 'assets/illus/meditation.png',
      'color': Colors.indigo,
    },
    'other': {
      'name': 'Khác',
      'image': 'assets/illus/default.png',
      'color': Colors.grey,
    },
  };

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description,
    );
    _selectedCategory = widget.task.category;
    _selectedDate = widget.task.startTime;
    _selectedTime = TimeOfDay.fromDateTime(widget.task.startTime);
    _durationMinutes = widget.task.duration.inMinutes;
    _isEditing = widget.isNewTask;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _confirmTask() async {
    final title = _titleController.text;
    final description = _descriptionController.text;

    final startTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final duration = Duration(minutes: _durationMinutes);

    try {
      await taskController.addTask(
        title: title,
        description: description,
        category: _selectedCategory,
        duration: duration,
        startTime: startTime,
      );

      await taskController.loadTodayTasks();
      await taskController.loadNextTaskForHome();


      // QUAY VỀ HOME – XÓA TOÀN BỘ STACK
      Get.offAll(() => const HomePage());

    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
      );
    }
  }


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

  @override
  Widget build(BuildContext context) {
    final category = _categories[_selectedCategory] ?? _categories['other']!;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FEFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isNewTask ? 'Xác nhận công việc' : 'Chi tiết công việc',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category card với ảnh illustration
            Center(
              child: Container(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 24),
                decoration: BoxDecoration(
                  color: const Color(0xFF90CAF9), // cùng tone card
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 4,
                      offset: const Offset(6, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // ẢNH
                    Image.asset(
                      category['image'] as String,
                      width: 110,
                      height: 110,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          _getCategoryIcon(_selectedCategory),
                          size: 90,
                          color: Colors.white,
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // CHIP CATEGORY
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25), // 👈 overlay nhẹ
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category['name'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),


            const SizedBox(height: 30),

            const Text(
              'Tiêu đề',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: _isEditing
                  ? TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Nhập tiêu đề...',
                      ),
                    )
                  : Text(
                      _titleController.text,
                      style: const TextStyle(fontSize: 18),
                    ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Mô tả',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: _isEditing
                  ? TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Nhập mô tả...',
                      ),
                    )
                  : Text(
                      _descriptionController.text.isEmpty
                          ? 'Không có mô tả'
                          : _descriptionController.text,
                      style: const TextStyle(fontSize: 16),
                    ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    'Ngày',
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    Icons.calendar_today,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInfoCard(
                    'Giờ bắt đầu',
                    _formatTime12h(_selectedTime), // dùng format 12h
                    Icons.access_time,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            _buildInfoCard(
              'Thời lượng',
              '${_durationMinutes ~/ 60} giờ ${_durationMinutes % 60} phút',
              Icons.timelapse,
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Xác nhận',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Quay lại chỉnh sửa',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
