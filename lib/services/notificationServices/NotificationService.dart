import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as notification;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {

  final notification.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = notification.FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    final notification.AndroidInitializationSettings initializationSettingsAndroid =
    notification.AndroidInitializationSettings('app_icon');

    final notification.IOSInitializationSettings initializationSettingsIOS =
    notification.IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {},
    );

    final notification.InitializationSettings initializationSettings =
    notification.InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }


  void selectNotification(String? payload) async {
    //Handle notification tapped logic here
    if (payload != null) {
      debugPrint("notification payload" + payload);
    }
  }

  void showNotification(String title, String body, DateTime dateTime) async {

    tz.initializeTimeZones();

    notification.AndroidInitializationSettings androidInitializationSettings = new notification.AndroidInitializationSettings("background");
    notification.IOSInitializationSettings iosInitializationSettings = notification.IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true
    );
    notification.InitializationSettings initializationSettings = new notification.InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);

    flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: selectNotification
    );

    notification.AndroidNotificationDetails androidNotificationDetails = notification.AndroidNotificationDetails("Channel ID", "Poam", importance: notification.Importance.max, priority: notification.Priority.high, playSound: true);

    notification.IOSNotificationDetails iosNotificationDetails = new notification.IOSNotificationDetails();
    notification.NotificationDetails notificationDetails = new notification.NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);

    //flutterLocalNotificationsPlugin.show(1, title, body, notificationDetails);

    Duration getTimeBetween = dateTime.difference(DateTime.now());
    await flutterLocalNotificationsPlugin.zonedSchedule(1, title, body, tz.TZDateTime.now(tz.local).add(getTimeBetween), notificationDetails, androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: notification.UILocalNotificationDateInterpretation.absoluteTime);
  }

  void showNotification2(String title, String body, DateTime dateTime) async {



  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        notification.IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: false,
      badge: true,
      sound: true,
    );
  }
}