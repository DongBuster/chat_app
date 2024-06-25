import 'package:chat_app/features/pages/chatPage/models/message_model.dart';
import 'package:chat_app/server/socket_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/features/pages/chatPage/chat_screen.dart';
import 'package:provider/provider.dart';
import '../../../common/widget_loading.dart';
import '../../../layout/header/viewModels/header_view_models.dart';
import 'homePageViewModel/home_page_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var socketService = SocketService();
  var homePageViewModel = HomePageViewModel();

  User? currentUser = FirebaseAuth.instance.currentUser;
  bool isScrolling = false;
  List<Map<String, dynamic>> listUnreadMessages = [];
  @override
  void initState() {
    // socketService.socket
    //     ?.emit('user_login', FirebaseAuth.instance.currentUser?.uid ?? '');

    socketService.socket?.on('receive_unread_message', _onReceiveUnreadMessage);
    super.initState();
  }

  void _onReceiveUnreadMessage(data) {
    MessageModel messageModel = MessageModel.fromJson(data);
    Map<String, dynamic> message = {messageModel.roomId: messageModel.text};
    setState(() {
      bool exit = false;

      for (var element in listUnreadMessages) {
        if (element.keys.first == message.keys.first) {
          element[message.keys.first] = message.values.first;
          // print('${element.keys.first}: ${element.values.first}');
          exit = true;
          // print(listUnreadMessages.length);

          break;
        }
      }
      if (!exit) {
        listUnreadMessages.add(message);
      }
      print(listUnreadMessages);
    });
  }

  String getMessageUnreadByRoomId(String key, List<Map<String, dynamic>> list) {
    for (var map in list) {
      if (map.containsKey(key)) {
        return map[key];
      }
    }
    return '';
  }

  @override
  void dispose() {
    socketService.socket
        ?.off('receive_unread_message', _onReceiveUnreadMessage);
    super.dispose();
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
        child: StreamBuilder(
          stream: homePageViewModel.getRooms(currentUser?.uid ?? ''),
          builder: (context, snapshot) {
            // print(currentUser!.uid);
            // print(snapshot.data![0].nameRoom);
            if (snapshot.hasData) {
              return ListView.builder(
                padding: const EdgeInsets.only(top: 60, bottom: 65),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            roomId: snapshot.data![index].id,
                            romName: snapshot.data![index].nameRoom,
                          ),
                        ),
                      );
                    },
                    leading: const Icon(Icons.person_2),
                    title: Text(snapshot.data![index].nameRoom),
                    subtitle: Text(getMessageUnreadByRoomId(
                        snapshot.data![index].id, listUnreadMessages)),
                  );
                },
              );
            }
            return const WidgetLoading();
          },
        ));
  }
}
