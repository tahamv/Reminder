import 'package:firebase_messaging/firebase_messaging.dart';

import 'local_notification.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // ignore: non_constant_identifier_names
  static String FCMToken = '';

  static void init() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        ReceivedNotification notification = ReceivedNotification(
            id: 1,
            title: message.notification?.title ?? '',
            body: message.notification?.body ?? '',
            payload: message.data['pageUrl'] ?? '',
            data: message.data);
        LocalNotificationService.showNotification(notification);
      }
    });
  }

  static void getFCMToken() {
    _firebaseMessaging.getToken().then((String? token) {
      FCMToken = token ?? '';
      print(FCMToken);
    });
  }

  static void subscribeFCM(String channel) {
    _firebaseMessaging.subscribeToTopic(channel);
  }
}
