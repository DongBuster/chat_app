import 'package:chat_app/home_page.dart';
import 'package:chat_app/loginchat.dart';
import 'package:flutter/material.dart';

import 'chat_page/chat_screen.dart';
import 'server/socket_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
    socketService.connectAndListen();
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
        body: const HomePage(userName: ''));
  }
}
