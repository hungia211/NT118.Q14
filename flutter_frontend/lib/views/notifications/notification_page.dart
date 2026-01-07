import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/notification_controller.dart';
import '../../models/app_notification.dart';
import '../../services/user_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationController controller =
  Get.find<NotificationController>();
  final UserService userService = UserService();

  String? avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final data = await userService.getUser(uid);
    if (!mounted) return;

    setState(() {
      avatarUrl = data?['avatar_url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FEFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.green),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Thông báo',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),

      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return const Center(
            child: Text('Không có thông báo'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final noti = controller.notifications[index];
            return _NotificationItem(
              noti: noti,
              avatarUrl: avatarUrl,
            );
          },
        );
      }),

      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text('Xem tất cả thông báo'),
          GestureDetector(
            onTap: controller.markAllAsRead,
            child: const Text(
              'Đánh dấu đã đọc tất cả',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final AppNotification noti;
  final String? avatarUrl;

  const _NotificationItem({
    required this.noti,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                ? NetworkImage(avatarUrl!)
                : const AssetImage('assets/images/ava.png')
            as ImageProvider,
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  noti.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  noti.message,
                  style: const TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatTime(noti.time),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          if (!noti.isRead)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Icon(
                Icons.circle,
                color: Colors.blue,
                size: 10,
              ),
            ),
        ],
      ),
    );
  }

  static String _formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

}
