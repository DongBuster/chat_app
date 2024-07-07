import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initialCloudMessage() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }
}
