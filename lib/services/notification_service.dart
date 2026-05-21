import 'package:videocalling/common/controllers/chat_screen_controller.dart';
import 'package:videocalling/common/routes/app_pages.dart';
import 'package:videocalling/doctor/controllers/dappointment_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationHelper {
  String? title;
  String? body;
  String? payload;
  String? id;
  String? type;
  BuildContext? context;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  NotificationHelper() {
    initialize();
  }

  Future<void> checkNotificationStatus(String id) async {
    final notifications = await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.getActiveNotifications();

    bool notificationShown = notifications!.any(
      (notification) =>
          notification.id == id && notification.channelId == 'channel_id',
    ); // Replace with your channel ID

    if (notificationShown) {}
    try {
      await flutterLocalNotificationsPlugin!.cancelAll();
    } on Exception catch (e) {}
  }

  initialize() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await flutterLocalNotificationsPlugin!.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        onSelectNotification(response.payload);
      },
    );

    await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  showNotification({
    String? title,
    String? body,
    String? payload,
    String? id,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        new AndroidNotificationDetails(
          id!,
          'Doctor Finder',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin!.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      if (payload.split(":")[0] == "user_id") {
        Get.toNamed(
          Routes.uAppointmentDetailScreen,
          arguments: {'id': payload.split(":")[1].toString()},
        );
      } else if (payload.split(":")[0] == "doctor_id") {
        await Get.toNamed(
          Routes.dAppointmentDetailScreen,
          arguments: {'id': payload.split(":")[1].toString()},
        );
        Get.delete<DAppointmentDetailsController>();
      } else if (payload.split(":")[0].toString().contains("100") ||
          payload.split(":")[0].toString().contains("117")) {
        await Get.toNamed(
          Routes.chatScreen,
          arguments: {
            'userName': payload.split(":")[1].toString(),
            'uid': payload.split(":")[0].toString(),
            'isUser': payload.split(":")[0].toString().contains("100")
                ? false
                : true,
          },
        );
        Get.delete<ChatController>();
      }
    }
  }

  void onDidReceiveLocalNotification(
    int id,
    String title,
    String? body,
    String? payload,
  ) async {
    if (payload != null) {
      if (payload.split(":")[0] == "user_id") {
        Get.toNamed(
          Routes.uAppointmentDetailScreen,
          arguments: {'id': payload.split(":")[1].toString()},
        );
      } else if (payload.split(":")[0] == "doctor_id") {
        await Get.toNamed(
          Routes.dAppointmentDetailScreen,
          arguments: {'id': payload.split(":")[1].toString()},
        );
        Get.delete<DAppointmentDetailsController>();
      } else if (payload.split(":")[0].toString().contains("100") ||
          payload.split(":")[0].toString().contains("117")) {
        await Get.toNamed(
          Routes.chatScreen,
          arguments: {
            'userName': payload.split(":")[1].toString(),
            'uid': payload.split(":")[0].toString(),
            'isUser': payload.split(":")[0].toString().contains("100")
                ? false
                : true,
          },
        );
        Get.delete<ChatController>();
      }
    }
  }
}
