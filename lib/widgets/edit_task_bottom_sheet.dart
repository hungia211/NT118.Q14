import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';

class EditTaskBottomSheet extends StatefulWidget {
  final Task task;
  final Function(Task updatedTask) onSave;

  const EditTaskBottomSheet({
    super.key,
    required this.task,
    required this.onSave,
  });

  @override
  State<EditTaskBottomSheet> createState() => _EditTaskBottomSheetState();
}

class _EditTaskBottomSheetState extends State<EditTaskBottomSheet> {
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;

  late DateTime _startTime;
  late Duration _duration;
  late String _status;
  late String _category;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.task.title);
    _descCtrl = TextEditingController(text: widget.task.description ?? '');
    _startTime = widget.task.startTime;
    _duration = widget.task.duration;
    _status = widget.task.status;
    _category = widget.task.category;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  // ================= PICKERS =================
  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startTime),
    );
    if (time != null) {
      setState(() {
        _startTime = DateTime(
          _startTime.year,
          _startTime.month,
          _startTime.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  Future<void> _pickDuration() async {
    final result = await showModalBottomSheet<int>(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [15, 30, 45, 60, 90, 120].map((m) {
              final selected = _duration.inMinutes == m;
              return ChoiceChip(
                label: Text('$m min'),
                selected: selected,
                onSelected: (_) => Navigator.pop(context, m),
              );
            }).toList(),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        _duration = Duration(minutes: result);
      });
    }
  }

  void _save() {
    final updatedTask = widget.task.copyWith(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      startTime: _startTime,
      duration: _duration,
      status: _status,
      category: _category,
    );

    widget.onSave(updatedTask);
    Navigator.pop(context);
  }


  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const Text(
                "Chỉnh sửa công việc",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _titleCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Tên công việc",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _pickTime,
                      child: Text(
                        DateFormat('hh:mm a').format(_startTime),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _pickDuration,
                      child: Text("${_duration.inMinutes} min"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Text(
                "Tình trạng",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                children: [
                  _statusChip('not-started', 'Chưa bắt đầu'),
                  _statusChip('in-progress', 'Đang tiến hành'),
                  _statusChip('done', 'Hoàn thành'),
                  _statusChip('failed', 'Không hoàn thành'),
                ],
              ),
              const SizedBox(height: 16),

              const Text(
                "Danh mục",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                children: [
                  _categoryChip('work', 'Công việc'),
                  _categoryChip('study', 'Học tập'),
                  _categoryChip('health', 'Sức khỏe'),
                  _categoryChip('relax', 'Nghỉ ngơi'),
                  _categoryChip('cook', 'Công việc nhà'),
                  _categoryChip('gardening', 'Chăm vườn'),
                  _categoryChip('meditation', 'Thiền'),
                  _categoryChip('other', 'Khác'),
                ],
              ),

              const SizedBox(height: 12),

              TextField(
                controller: _descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Mô tả công việc (tùy chọn)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text("Lưu"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _statusChip(String value, String label) {
    final selected = _status == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        setState(() => _status = value);
      },
    );
  }

  Widget _categoryChip(String value, String label) {
    final selected = _category == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        setState(() => _category = value);
      },
    );
  }

}

