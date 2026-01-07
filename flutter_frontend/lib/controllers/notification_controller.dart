import 'package:get/get.dart';
import '../models/app_notification.dart';

class NotificationController extends GetxController {
  final RxList<AppNotification> notifications = <AppNotification>[].obs;

  /// badge đỏ
  RxBool hasUnread = false.obs;

  void addNotification(AppNotification noti) {
    notifications.insert(0, noti);
    notifications.sort(
          (a, b) => b.time.compareTo(a.time),
    );
    notifications.refresh();
    hasUnread.value = true;
  }

  void markAllAsRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
    hasUnread.value = false;
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
    }

    hasUnread.value =
        notifications.any((element) => element.isRead == false);
  }
}
