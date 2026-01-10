import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/task_draft.dart';
import '../../controllers/task_controller.dart';
import '../../widgets/task_card_preview.dart';

class AiPreviewPage extends StatefulWidget {
  final List<TaskDraft> tasks;

  const AiPreviewPage({super.key, required this.tasks});

  @override
  State<AiPreviewPage> createState() => _AiPreviewPageState();
}

class _AiPreviewPageState extends State<AiPreviewPage> {
  late List<TaskDraft> drafts;

  @override
  void initState() {
    drafts = List.from(widget.tasks);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FEFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black54),
          onPressed: () => _showCancelDialog(),
        ),

        actions: [
          TextButton(
            onPressed: () => _showCancelDialog(),
            child: const Text('Hủy tất cả', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Column(
                children: const [
                  Text(
                    "Đề xuất lịch trình cho ngày mai",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Vuốt phải để sửa • Vuốt trái để xóa",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // ================= LIST =================
            Expanded(
              child: drafts.isEmpty
                  ? const Center(
                child: Text(
                  "Không còn công việc nào 😴",
                  style: TextStyle(color: Colors.grey),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.only(bottom: 120),
                itemCount: drafts.length,
                itemBuilder: (context, index) {
                  final task = drafts[index];

                  return Dismissible(
                    key: ValueKey('${task.title}-$index'),
                    direction: DismissDirection.horizontal,
                    background: _editBg(),
                    secondaryBackground: _deleteBg(),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        _editTask(task, index);
                        return false;
                      } else {
                        setState(() => drafts.removeAt(index));
                        return true;
                      }
                    },
                    child: TaskCardPreview(task: task),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ================= CONFIRM =================
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          12,
          24,
          12 + MediaQuery.of(context).padding.bottom,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          onPressed: drafts.isEmpty ? null : _confirm,
          child: const Text(
            "XÁC NHẬN & THÊM VÀO LỊCH",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // ================= ACTIONS =================

  void _showCancelDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Hủy đề xuất?'),
        content: const Text('Bạn có chắc muốn hủy tất cả đề xuất của AI?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text('Hủy bỏ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirm() async {
    final controller = Get.find<TaskController>();

    for (final t in drafts) {
      await controller.addTask(
        title: t.title,
        category: t.category,
        duration: Duration(minutes: t.durationMinutes),
        startTime: t.startTime,
      );
    }

    Get.back();
    Get.snackbar(
      'Thành công',
      'Đã thêm ${drafts.length} công việc vào lịch',
    );
  }

  void _editTask(TaskDraft task, int index) async {
    final result = await Get.bottomSheet<TaskDraft>(
      _EditTaskSheet(task: task),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );

    if (result != null) {
      setState(() => drafts[index] = result);
    }
  }

  Widget _editBg() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(left: 24),
    decoration: BoxDecoration(
      color: Colors.green.shade100,
      borderRadius: BorderRadius.circular(28),
    ),
    child: const Icon(Icons.edit, color: Colors.green),
  );

  Widget _deleteBg() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 24),
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(28),
    ),
    child: const Icon(Icons.delete, color: Colors.white),
  );
}

// ================= EDIT BOTTOM SHEET =================

class _EditTaskSheet extends StatefulWidget {
  final TaskDraft task;
  const _EditTaskSheet({required this.task});

  @override
  State<_EditTaskSheet> createState() => _EditTaskSheetState();
}

class _EditTaskSheetState extends State<_EditTaskSheet> {
  late TextEditingController _titleController;
  late TimeOfDay _startTime;
  late int _duration;
  late String _category;

  final List<int> _durationOptions = [15, 30, 45, 60, 90, 120, 180];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _startTime = TimeOfDay.fromDateTime(widget.task.startTime);
    _duration = widget.task.durationMinutes;
    _category = widget.task.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Chỉnh sửa công việc',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Tên công việc',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Giờ bắt đầu'),
            trailing: TextButton(
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _startTime,
                );
                if (picked != null) setState(() => _startTime = picked);
              },
              child: Text(
                _startTime.format(context),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Thời lượng'),
            trailing: DropdownButton<int>(
              value: _durationOptions.contains(_duration) ? _duration : 60,
              items: _durationOptions
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text('$e phút'),
              ))
                  .toList(),
              onChanged: (v) => setState(() => _duration = v!),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              final newTask = TaskDraft(
                title: _titleController.text,
                category: _category,
                startTime: DateTime(
                  widget.task.startTime.year,
                  widget.task.startTime.month,
                  widget.task.startTime.day,
                  _startTime.hour,
                  _startTime.minute,
                ),
                durationMinutes: _duration,
              );
              Get.back(result: newTask);
            },
            child: const Text('Lưu thay đổi'),
          ),
        ],
      ),
    );
  }
}
