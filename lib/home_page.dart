import 'package:chat_app/server/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/chat_page/chat_screen.dart';

class HomePage extends StatefulWidget {
  final String userName;
  const HomePage({
    super.key,
    required this.userName,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var socketService = SocketService();

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
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChatScreen(
                          currentUserName: widget.userName, romName: 'user1')));
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
                      builder: (_) => ChatScreen(
                          currentUserName: widget.userName, romName: 'user2')));
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
                      builder: (_) => ChatScreen(
                          currentUserName: widget.userName, romName: 'user3')));
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
