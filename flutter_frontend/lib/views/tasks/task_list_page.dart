import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/task.dart';
import '../../widgets/task_card_with_status.dart';
import '../../widgets/edit_task_bottom_sheet.dart';
import '../calendar/calendar_page.dart';
import '../home/home_page.dart';
import '../statistics/statistics_page.dart';
import 'package:get/get.dart';
import '../../controllers/task_controller.dart';

class TaskListPage extends StatefulWidget {
  final String userId;

  const TaskListPage({super.key, required this.userId});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  // late List<Task> list;

  final TaskController controller = Get.put(TaskController());

  @override
  void initState() {
    super.initState();

    // debug userId
    print('TaskListPage userId: ${widget.userId}');

    // Đảm bảo Rx value chỉ được set sau khi widget build xong
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadTasksByUser(widget.userId);
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
                      MaterialPageRoute(builder: (_) => const HomePage()),
                    );
                  },
                  child: const Icon(Icons.home, size: 30, color: Colors.black),
                ),
              ),
            ),

            // GRID
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(Icons.grid_view, color: Colors.green),
                  ),
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
                      MaterialPageRoute(builder: (_) => const StatisticsPage()),
                    );
                  },
                  child: Center(
                    child: Icon(
                      Icons.circle_outlined,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
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
                      MaterialPageRoute(builder: (_) => const CalendarPage()),
                    );
                  },
                  child: Center(
                    child: Icon(
                      Icons.calendar_today,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= HEADER =================
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Danh sách công việc hôm nay!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  Center(
                    child: StreamBuilder<DateTime>(
                      stream: Stream.periodic(
                        const Duration(seconds: 20),
                        (_) => DateTime.now(),
                      ).startWith(DateTime.now()),
                      builder: (context, snapshot) {
                        final now = snapshot.data ?? DateTime.now();

                        return Text(
                          getVietnameseDateTime(now),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ---------- TASK LIST ----------
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.tasks.isEmpty) {
                  return const Center(
                    child: Text(
                      "Không có công việc hôm nay 😴",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 120),
                  itemCount: controller.tasks.length,
                  itemBuilder: (context, index) {
                    final task = controller.tasks[index];

                    return Dismissible(
                      key: ValueKey(task.id),
                      direction: DismissDirection.horizontal,

                      // ===== VUỐT PHẢI → SỬA =====
                      background: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 24),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: const Icon(Icons.edit, color: Colors.green),
                      ),

                      // ===== VUỐT TRÁI → XÓA =====
                      secondaryBackground: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),

                      // ===== PHÂN BIỆT SỬA / XÓA =====
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          // SỬA
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(28),
                              ),
                            ),
                            builder: (_) => EditTaskBottomSheet(
                              task: task,
                              onSave: (updatedTask) {
                                // sửa trực tiếp trong controller
                                controller.editTask(index, updatedTask);
                              },
                            ),
                          );
                          return false;
                        } else {
                          // XÓA
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Xác nhận xóa"),
                              content: const Text(
                                "Bạn có chắc chắn muốn xóa công việc này không?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("HỦY"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    "XÓA",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            await controller.deleteTask(index);
                          }
                          return confirmed;
                        }
                      },

                      // ===== CHỈ CHẠY KHI XÓA =====
                      onDismissed: (_) {
                        controller.tasks.removeAt(index);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Đã xóa công việc")),
                        );
                      },

                    child: SizedBox(
                      height: 140,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // ===== SHADOW DẠNG ĐẾ (GIỐNG LayeredTaskCard) =====
                          Positioned(
                            bottom: 4,
                            left: 26,
                            right: 16,
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // ===== CARD CHÍNH =====
                          Positioned.fill(
                            child: TaskCardWithStatus(task: task),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getVietnameseDateTime(DateTime now) {
    const weekdays = [
      "Thứ Hai",
      "Thứ Ba",
      "Thứ Tư",
      "Thứ Năm",
      "Thứ Sáu",
      "Thứ Bảy",
      "Chủ Nhật",
    ];

    const months = [
      "tháng 1",
      "tháng 2",
      "tháng 3",
      "tháng 4",
      "tháng 5",
      "tháng 6",
      "tháng 7",
      "tháng 8",
      "tháng 9",
      "tháng 10",
      "tháng 11",
      "tháng 12",
    ];

    final weekdayName = weekdays[(now.weekday - 1) % 7];
    final monthName = months[(now.month - 1) % 12];

    String hour = now.hour.toString().padLeft(2, '0');
    String minute = now.minute.toString().padLeft(2, '0');

    return "$hour:$minute - $weekdayName, ${now.day} $monthName ${now.year}";
  }
}
