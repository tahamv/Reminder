import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_on_class/pages/add_reminder.dart';
import 'package:test_on_class/pages/reminder_list.dart';
import 'package:test_on_class/services/notification/local_notification.dart';
import 'package:test_on_class/services/notification/notification.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzl;

import 'const/const.dart';
import 'model/reminder_model.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var databasesPath = await getDatabasesPath();
  reminderProvider = ReminderProvider();
// Make sure the directory exists
  try {
    await Directory(databasesPath).create(recursive: true);
  } catch (_) {}

  await reminderProvider.open(databasesPath+"/test.db");

  await Firebase.initializeApp(
  );
  LocalNotificationService.init();
  NotificationService.init();
  NotificationService.getFCMToken();
  NotificationService.subscribeFCM('all');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  tzl.initializeTimeZones();
  // tz.setLocalLocation(tz.getLocation("IRST"));
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ReminderList(),
    );
  }
}




