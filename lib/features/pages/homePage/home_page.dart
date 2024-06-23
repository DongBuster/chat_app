import 'package:chat_app/server/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/chat_page/chat_screen.dart';
import 'package:provider/provider.dart';

import '../../../layout/header/header.dart';
import '../../../layout/header/viewModels/header_view_models.dart';
import '../../../layout/header/views/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var socketService = SocketService();
  bool isScrolling = false;
  List<Map<String, dynamic>> listUnreadMessages = [
    {'user1': ''},
    {'user2': ''},
    {'user3': ''},
  ];
  @override
  void initState() {
    socketService.socket?.on('receive_unread_message', (data) {
      // print('receive: ${data['room']}');
      for (var e in listUnreadMessages) {
        if (e.keys.first == data['room']) {
          setState(() {
            e[e.keys.first] = data['message'];
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(listUnreadMessages[0]['user1']);
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis == Axis.vertical &&
            notification.metrics.pixels >= 30) {
          Provider.of<HeaderViewModel>(context, listen: false)
              .setIsScrollingTrue();
        }
        if (notification.metrics.axis == Axis.vertical &&
            notification.metrics.pixels < 30) {
          Provider.of<HeaderViewModel>(context, listen: false)
              .setIsScrollingFalse();
        }
        return false;
      },
      child: ListView(
        padding: const EdgeInsets.only(top: 60, bottom: 65),
        children:
            // List.generate(
            //     20,
            //     (index) => ListTile(
            //           leading: const Icon(Icons.person_2),
            //           title: Text('user$index'),
            //         ))
            [
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ChatScreen(
                          currentUserName: '', romName: 'user1')));
            },
            leading: const Icon(Icons.person_2),
            title: const Text('user1'),
            subtitle: Text('${listUnreadMessages[0]['user1']}'),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ChatScreen(
                          currentUserName: '', romName: 'user2')));
            },
            leading: const Icon(Icons.person_2),
            title: const Text('user2'),
            subtitle: Text('${listUnreadMessages[1]['user2']}'),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ChatScreen(
                          currentUserName: '', romName: 'user3')));
            },
            leading: const Icon(Icons.person_2),
            title: const Text('user3'),
            subtitle: Text('${listUnreadMessages[2]['user3']}'),
          ),
        ],
      ),
    );
  }
}
