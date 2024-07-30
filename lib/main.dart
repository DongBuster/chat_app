import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'FCM/local_notification_service.dart';
import 'firebase/firebase_options.dart';
import 'package:provider/provider.dart';

import 'layout/header/viewModels/header_view_models.dart';
import 'routes/route_config.dart';
import 'socketIO/socketIO_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://ybaseliahybaruuuabqt.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InliYXNlbGlhaHliYXJ1dXVhYnF0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTg5NjExMjYsImV4cCI6MjAzNDUzNzEyNn0.tTRrHL0A68WVoJZaXwaYdkHFbi1IySuuKF-np85AoIo',
  );
  LocalNotificationService().requestPermission();
  LocalNotificationService().init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => HeaderViewModel(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  var socketService = SocketService();
  firebase_auth.User? currentUser =
      firebase_auth.FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // setStatusUserOnline();
    socketService.connectAndListen();
    notificationHandler();
    super.initState();
  }

  void notificationHandler() {
    FirebaseMessaging.onMessage.listen((remoteMessage) async {
      // print(remoteMessage.notification!.title);
      LocalNotificationService().showNotification(remoteMessage);
    });
  }

  Future<void> setStatusUserOnline() async {
    // print(currentUser!.uid);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .update({'isOnline': 'true'});
  }

  Future<void> setStatusUserOffline() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .update({'isOnline': 'false'});
    // print('offline');
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    print(state);
    if (state == AppLifecycleState.paused) {
      print('detached');
      await setStatusUserOffline();
      socketService.dispose();
    }
    if (state == AppLifecycleState.resumed) {
      await setStatusUserOnline();
      socketService.connectAndListen();
    }
  }

  @override
  @mustCallSuper
  @protected
  void dispose() {
    socketService.dispose();
    WidgetsBinding.instance.removeObserver(this);
    // _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: routeConfig,
    );
  }
}
