import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase/firebase_options.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/features/pages/homePage/home_page.dart';
import 'layout/header/viewModels/header_view_models.dart';
import 'routes/route_config.dart';
import 'server/socket_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  AppLifecycleState? _notification;
  var socketService = SocketService();

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       socketService.connectAndListen();
  //       print("app in resumed");
  //       break;
  //     case AppLifecycleState.inactive:
  //       // print("app in inactive");
  //       break;
  //     case AppLifecycleState.paused:
  //       socketService.dispose();

  //       print("app in paused");
  //       break;
  //     case AppLifecycleState.detached:
  //       socketService.dispose();

  //       // print("app in detached");
  //       break;
  //     case AppLifecycleState.hidden:
  //       socketService.dispose();

  //     // TODO: Handle this case.
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: const HomePage());
  }
}
