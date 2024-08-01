import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalNotificationService {
  Future<void> requestPermission() async {
    PermissionStatus status = await Permission.notification.request();
    if (status != PermissionStatus.granted) {
      throw Exception("Permission not granted");
    }
  }

  //--- save FCMToken device user ----
  final firebaseFirestore = FirebaseFirestore.instance;
  final _currentUser = FirebaseAuth.instance.currentUser;
  Future<void> uploadFcmToken() async {
    try {
      // FirebaseMessaging.o
      await FirebaseMessaging.instance.getToken().then((token) async {
        print('token: $token');
        await firebaseFirestore
            .collection('FcmUser')
            .doc(_currentUser!.uid)
            .set({'userId': _currentUser.uid, 'notificationToken': token});
      });
      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        print('onTokenRefesh: $token');
        await firebaseFirestore
            .collection('FcmUser')
            .doc(_currentUser!.uid)
            .update({'notificationToken': token});
      });
    } catch (e) {
      print(e.toString());
    }
  }

  //--- Initialize native android notification ---
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //--- setup and show notification ----
  showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id',
      'Channel Name',
      channelDescription: 'Channel Description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    int notificationId = 1;
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
      payload: 'Not present',
    );
  }
}
