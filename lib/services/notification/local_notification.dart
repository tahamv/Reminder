import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
// for using sound in notification create sound.mp3 and sound.aiff.
// sound.mp3: under android/app/src/main/res/raw folder
// sound.aiff: under ios folder

class ReceivedNotification {
  ReceivedNotification({required this.id, required this.title, required this.body, required this.payload, required this.data});

  final int id;
  final String title;
  final String body;
  final String payload;
  final Map data;
}

class LocalNotificationService {
  static String link = "";
  static const String appName = 'reminder';
  static const String appId = 'reminder-2023';
  static const String appDescription = 'reminder notification channel';

  // using stream to listen to changes
  static final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();
  static final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_stat_ic_notification');
  static final DarwinInitializationSettings darwinInitializationSettings =
      DarwinInitializationSettings(onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
    didReceiveLocalNotificationSubject
        .add(ReceivedNotification(id: id, title: title ?? '', body: body ?? '', payload: payload ?? '', data: {}));
  });
  static final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: darwinInitializationSettings, macOS: darwinInitializationSettings);

  static void init() {
    requestPermissions();
    selectNotification();
  }

  static void requestPermissions() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static void selectNotification() async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream.listen((ReceivedNotification receivedNotification) {
      showNotification(receivedNotification);
    });
  }

  static void showNotification(ReceivedNotification receivedNotification) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(appId, appName,
        channelDescription: appDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        priority: Priority.high,
        color: Color(0xFFa90d80),
        sound: RawResourceAndroidNotificationSound('sound'),
        ticker: 'ticker');
    const DarwinNotificationDetails darwinPlatformChannelSpecifics = DarwinNotificationDetails(sound: 'sound.aiff');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: darwinPlatformChannelSpecifics, macOS: darwinPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(
        receivedNotification.id, receivedNotification.title, receivedNotification.body, platformChannelSpecifics);
  }


  static void showNotificationScheduled(ReceivedNotification receivedNotification,tz.TZDateTime time) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(appId, appName,
        channelDescription: appDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        priority: Priority.high,
        color: Color(0xFFa90d80),
        sound: RawResourceAndroidNotificationSound('sound'),
        ticker: 'ticker');
    const DarwinNotificationDetails darwinPlatformChannelSpecifics = DarwinNotificationDetails(sound: 'sound.aiff');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: darwinPlatformChannelSpecifics, macOS: darwinPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.zonedSchedule(
        receivedNotification.id, receivedNotification.title, receivedNotification.body, time,platformChannelSpecifics, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,);
  }

  static void testNotification() {
    // test code
    ReceivedNotification notification = ReceivedNotification(
        id: 1,
        title: "message['notification']['title'].toString()",
        body: "message['notification']['body'].toString()",

        payload: "https://google.com",
        data: {"pageUrl": "https://google.com"});
    LocalNotificationService.showNotification(notification);
  }
}
