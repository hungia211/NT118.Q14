import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../services/ai_suggestion_service.dart';
import '../../widgets/black_button.dart';
import '../../widgets/task_card.dart';
import '../../controllers/task_controller.dart';
import '../../services/task_service.dart';
import 'dart:async';
import '../../services/book_service.dart';
import '../../widgets/book_card.dart';
import 'package:rxdart/rxdart.dart';

import '../ai/ai_preview_page.dart';
import '../calendar/calendar_page.dart';
import '../profile/profile_page.dart';
import '../statistics/statistics_page.dart';
import '../tasks/add_task_page.dart';
import '../tasks/task_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/user_service.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart';

import '../../controllers/pomodoro_controller.dart';
import '../../services/pomodoro_overlay.dart';
import '../focus/pomodoro_page.dart';
import '../notifications/notification_page.dart';
import '../../controllers/notification_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskService taskService = TaskService();
  final TaskController taskController = Get.find<TaskController>();
  final BookService bookService = BookService();
  final UserService userService = UserService();

  final PomodoroController pomodoroController = Get.put(PomodoroController());

  final NotificationController notiController =
      Get.find<NotificationController>();

  late final AuthService authService;
  late final String userId;

  String? userName;
  String? avatarUrl;

  // các từ khóa đề xuất
  final List<String> vietnamKeywords = [
    "quản lý thời gian",
    "làm việc hiệu quả",
    "tối ưu hiệu suất",
  ];

  late final Future<List<Task>> _tasksFuture = taskService.getTasks();
  late final Future<List> _booksFuture = bookService.fetchBooks(
    vietnamKeywords[DateTime.now().millisecondsSinceEpoch %
        vietnamKeywords.length],
  );

  @override
  void initState() {
    super.initState();
    authService = Get.find<AuthService>();
    final uid = authService.currentUserId;
    if (uid == null) {
      // chưa login → redirect hoặc return
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskController.loadTodayTasks();
      taskController.loadNextTaskForHome();
    });

    userId = uid;
    _loadUser();
  }

  Future<void> _loadUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final data = await userService.getUser(uid);
    setState(() {
      userName = data?['name'];
      avatarUrl = data?['avatar_url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FEFB),

      // BOTTOM NAVIGATION
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
            // HOME (selected)
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.home, color: Colors.green),
                ),
              ),
            ),

            // GRID
            Expanded(
              child: Center(
                child: InkWell(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TaskListPage()),
                    );
                  },
                  child: const Icon(Icons.grid_view, size: 28),
                ),
              ),
            ),

            // BIG PLUS BUTTON
            Expanded(
              child: Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddTaskPage()),
                    );
                  },
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

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      notiController.markAllAsRead();
                      Get.to(() => NotificationPage());
                    },
                    child: Obx(() {
                      return SizedBox(
                        width: 36,
                        height: 36,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(Icons.notifications, size: 36),
                            if (notiController.hasUnread.value)
                              Positioned(
                                right: 2,
                                top: 2,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  ),

                  const SizedBox(width: 16), // ← thêm padding trái cho Search

                  const SizedBox(
                    width: 16,
                  ), // ← thêm padding phải giữa Search và Avatar

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage:
                          avatarUrl != null && avatarUrl!.isNotEmpty
                          ? NetworkImage(avatarUrl!)
                          : const AssetImage("assets/images/ava.png")
                                as ImageProvider,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // WELCOME TEXT
              Center(
                child: Text(
                  userName == null ? "Chào mừng bạn!" : "Chào mừng $userName!",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Center(
                child: Text(
                  "Danh sách công việc hôm nay!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),

              Center(child: _buildClock()),

              const SizedBox(height: 30),

              // TASK CARD
              Obx(() {
                final task = taskController.nextTask.value;

                if (task == null) {
                  return const Text("Không có công việc sắp tới 😴");
                }

                return Column(
                  children: [
                    LayeredTaskCard(context, task),
                    const SizedBox(height: 15),
                    BlackButton(
                      text: "XEM TẤT CẢ",
                      width: 130,
                      height: 40,
                      fontSize: 12,
                      borderRadius: 40,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => TaskListPage()),
                        );
                      },
                    ),
                  ],
                );
              }),

              const SizedBox(height: 30),

              GestureDetector(
                onTap: () {
                  pomodoroController.start();

                  PomodoroOverlay.show(
                    onTap: () {
                      Get.to(() => PomodoroPage());
                      PomodoroOverlay.hide();
                    },
                    onClose: () {
                      pomodoroController.stop();
                      PomodoroOverlay.hide();
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.timer, color: Colors.redAccent, size: 28),
                          SizedBox(width: 12),
                          Text(
                            "Bắt đầu Pomodoro",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.play_arrow, color: Colors.redAccent),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // PROGRESS TITLE
              const Center(
                child: Text(
                  "Tiến độ công việc hôm nay!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 10),

              // CUSTOM PROGRESS BAR
              Obx(() {
                final progress = taskController.todayProgress.value;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final fullWidth = constraints.maxWidth;
                    final progressWidth = fullWidth * progress;

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Nền xám
                        Container(
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                        ),

                        // Thanh xanh
                        Positioned(
                          left: 0,
                          child: Container(
                            height: 28,
                            width: progressWidth,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),

                        // Text %
                        Text(
                          "${(progress * 100).toStringAsFixed(0)}%",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),

              const SizedBox(height: 60),

              // DISCOVER BANNER
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // ---- MAIN CARD ----
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                    height: 140, // mỏng hơn theo yêu cầu
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF7DE9B6), // xanh nhạt phía trên
                          Colors.white, // trắng phía dưới
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Đề xuất công việc!",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Bạn đã sẵn sàng chưa?",
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),

                        // BUTTON
                        ElevatedButton(
                          onPressed: () async {
                            final controller = Get.find<TaskController>();

                            Get.dialog(
                              const Center(child: CircularProgressIndicator()),
                              barrierDismissible: false,
                            );

                            try {
                              final drafts = await controller.generateAiTasks();

                              Get.back();
                              Get.to(() => AiPreviewPage(tasks: drafts));
                            } catch (e) {
                              Get.back();
                              Get.snackbar('Error', e.toString());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "BẮT ĐẦU",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ---- IMAGE FLOATING (NỔI LÊN, SANG PHẢI) ----
                  Positioned(
                    top: -60, // nổi lên hơn
                    right: 0, // đẩy sang phải nhiều hơn
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.asset(
                        "assets/images/discover.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // BOOKS SECTION
              const Text(
                "Những cuốn sách bạn nên đọc:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              FutureBuilder(
                future: _booksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 140,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Text("Không thể tải sách 😢");
                  }

                  final books = snapshot.data as List;

                  return SizedBox(
                    height: 210,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index]["volumeInfo"];

                        final image = book["imageLinks"]?["thumbnail"];

                        final title = book["title"] ?? "No title";

                        String fixUrl(String? url) {
                          if (url == null) return "https://books.google.com/";
                          if (url.startsWith("http://")) {
                            return url.replaceFirst("http://", "https://");
                          }
                          return url;
                        }

                        print("🔗 Book link: ${fixUrl(book["infoLink"])}");

                        return BookCard(
                          imageUrl: image,
                          title: title,
                          previewUrl: fixUrl(
                            book["infoLink"] ??
                                book["previewLink"] ??
                                book["canonicalVolumeLink"],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // WHY USE APP SECTION
              Center(
                child: Column(
                  children: const [
                    Icon(Icons.stacked_line_chart, size: 45),
                    SizedBox(height: 12),

                    Text(
                      "Hiệu suất tạo nên sự tiến bộ",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 12),

                    Image(image: AssetImage("assets/images/performance.png")),

                    SizedBox(height: 8),

                    Text(
                      "Tại sao nên sử dụng ứng dụng này?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Ứng dụng cung cấp các công cụ để bạn tổ chức, ưu tiên "
                      "và quản lý công việc. Đồng thời giúp bạn duy trì sự tập trung "
                      "và hoàn thành từng mục trong danh sách của mình.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // QUOTE SECTION
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // QUOTE TEXT
                  SizedBox(
                    width: double.infinity,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                        children: const [
                          TextSpan(text: "“ "),
                          TextSpan(text: "Không có việc gì khó,\n"),
                          TextSpan(text: "Chỉ sợ lòng "),
                          TextSpan(
                            text: "KHÔNG BỀN",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: ". "),
                          TextSpan(text: "”"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // AVATAR (tự căn giữa vì Column center)
                  const CircleAvatar(
                    radius: 36,
                    backgroundImage: AssetImage("assets/images/ChuTichHCM.jpg"),
                    backgroundColor: Colors.transparent,
                  ),

                  const SizedBox(height: 12),

                  // AUTHOR NAME
                  const Text(
                    "Hồ Chí Minh",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 4),

                  // AUTHOR ROLE
                  const Text(
                    "Chủ tịch nước Việt Nam",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

Widget LayeredTaskCard(BuildContext context, Task task) {
  return SizedBox(
    height: 140,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        // SHADOW 3D DƯỚI ĐÁY (nằm dưới tất cả)
        Positioned(
          bottom: 4,
          left: 20,
          right: -4,
          child: Container(
            height: 145,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(50),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),

        Positioned(
          right: 0,
          top: -12,
          child: _layer(context, Colors.red.shade300),
        ),

        Positioned(
          right: 4,
          top: -8,
          child: _layer(context, Colors.orange.shade300),
        ),

        Positioned(
          right: 8,
          top: -4,
          child: _layer(context, Colors.green.shade800),
        ),

        Positioned(top: 0, left: 8, right: 12, child: TaskCard(task: task)),
      ],
    ),
  );
}

Widget _layer(BuildContext context, Color color) {
  return Container(
    height: 130,
    width: MediaQuery.of(context).size.width - 60,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(30),
    ),
  );
}

Widget buildBook(String asset) {
  return Container(
    width: 100,
    margin: const EdgeInsets.only(right: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Image.asset(asset, fit: BoxFit.cover),
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

Widget _buildClock() {
  return StreamBuilder<DateTime>(
    stream: Stream.periodic(
      const Duration(seconds: 60),
      (_) => DateTime.now(),
    ).startWith(DateTime.now()),
    builder: (context, snapshot) {
      final now = snapshot.data ?? DateTime.now();
      return Text(
        getVietnameseDateTime(now),
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      );
    },
  );
}
