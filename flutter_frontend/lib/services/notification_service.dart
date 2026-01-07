import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;
import 'package:flutter/material.dart';
import '../controllers/notification_controller.dart';
import '../models/app_notification.dart';
import 'package:get/get.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tzData.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        final notiController = Get.find<NotificationController>();

        final data = response.payload != null
            ? jsonDecode(response.payload!)
            : {};

        if (!notiController.notifications.any(
              (n) => n.id == response.id.toString(),
        )) {
          notiController.addNotification(
            AppNotification(
              id: response.id.toString(),
              title: data['title'] ?? 'Thông báo',
              message: data['body'] ?? '',
              time: DateTime.now(),
              isTriggered: true,
            ),
          );
        }

      },

    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();
  }

  static Future<void> scheduleTaskNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    if (!scheduledTime.isAfter(DateTime.now())) return;

    const androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      payload: jsonEncode({
        'title': title,
        'body': body,
      }),
    );
  }
}
