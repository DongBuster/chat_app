import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase/firebase_options.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/features/pages/homePage/home_page.dart';
import 'layout/header/viewModels/header_view_models.dart';
import 'routes/route_config.dart';
import 'server/socket_service.dart';

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

class _MyAppState extends State<MyApp> {
  var socketService = SocketService();

  @override
  void initState() {
    socketService.connectAndListen();

    super.initState();
  }

  @override
  void dispose() {
    socketService.dispose();
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
