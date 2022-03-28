import 'package:flutter_local_notifications/flutter_local_notifications.dart' as notification;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {

  late notification.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> init() async {
    final notification.AndroidInitializationSettings initializationSettingsAndroid =
    notification.AndroidInitializationSettings('app_icon');

    final notification.IOSInitializationSettings initializationSettingsIOS =
    notification.IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      //onDidReceiveLocalNotification: onDidReceiveLocalNotification,
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
  }

  void showNotification(String title, String body, DateTime dateTime) {

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Europe/Warsaw"));

    var scheduleDateTime = tz.TZDateTime.from(dateTime, tz.getLocation("Europe/Warsaw"));

    notification.AndroidInitializationSettings androidInitializationSettings = new notification.AndroidInitializationSettings("background");
    notification.IOSInitializationSettings iosInitializationSettings = notification.IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true
    );
    notification.InitializationSettings initializationSettings = new notification.InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);
    flutterLocalNotificationsPlugin = new notification.FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: selectNotification
    );

    notification.AndroidNotificationDetails androidNotificationDetails = notification.AndroidNotificationDetails("Channel ID", "Poam", importance: notification.Importance.max, priority: notification.Priority.high, playSound: true);

    notification.IOSNotificationDetails iosNotificationDetails = new notification.IOSNotificationDetails();
    notification.NotificationDetails notificationDetails = new notification.NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);

    //flutterLocalNotificationsPlugin.show(1, title, body, notificationDetails);
    flutterLocalNotificationsPlugin.zonedSchedule(1, title, body, scheduleDateTime, notificationDetails, androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: notification.UILocalNotificationDateInterpretation.absoluteTime);
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