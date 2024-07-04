import 'package:chat_app/features/pages/chatPage/models/message_model.dart';
import 'package:chat_app/server/socket_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/features/pages/chatPage/chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:localstore/localstore.dart';
import '../../../common/widget_loading.dart';
import '../../../layout/header/viewModels/header_view_models.dart';
import 'homePageViewModel/home_page_view_model.dart';
import 'widgets/room_chat.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  var socketService = SocketService();
  var homePageViewModel = HomePageViewModel();

  User? currentUser = FirebaseAuth.instance.currentUser;
  bool isScrolling = false;
  bool isUnread = false;

  Map<String, Map<String, dynamic>> lastMessages = {};
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    socketService.socket?.on('receive_unread_message', _onReceiveUnreadMessage);
    socketService.socket?.on('receive_last_message', _onReceiveLastMessage);

    intialUnreadMessage();
    super.initState();
  }

  void _onReceiveUnreadMessage(data) {
    // print(data);
    MessageModel messageModel = MessageModel.fromJson(data);

    setState(() {
      bool exit = false;

      for (var key in lastMessages.keys) {
        if (key == messageModel.roomId) {
          lastMessages[messageModel.roomId]?['text'] = messageModel.text;
          lastMessages[messageModel.roomId]?['isRead'] = 'false';
          exit = true;
          break;
        }
      }
      if (exit == false) {
        lastMessages[messageModel.roomId] = {
          'text': messageModel.text,
          'isRead': 'false'
        };
      }

      // print(unreadMessages);
    });
  }

  void _onReceiveLastMessage(data) async {
    MessageModel messageModel = MessageModel.fromJson(data);

    // print('last$data');
    setState(() {
      bool exit = false;

      for (var key in lastMessages.keys) {
        if (key == messageModel.roomId) {
          lastMessages[messageModel.roomId]?['text'] = messageModel.text;
          lastMessages[messageModel.roomId]?['isRead'] = 'true';
          exit = true;
          break;
        }
      }
      if (exit == false) {
        lastMessages[messageModel.roomId] = {
          'text': messageModel.text,
          'isRead': 'true'
        };
      }
    });
  }

  void saveLastMessage() {
    final db = Localstore.instance;
    db.collection('message').doc('lastMessages').set(lastMessages);
  }

  Future<void> intialUnreadMessage() async {
    final db = Localstore.instance;
    final data = await db.collection('message').doc('lastMessages').get();
    // print('data save :$data');
    setState(() {
      lastMessages = data?.map(
              (key, value) => MapEntry(key, value as Map<String, dynamic>)) ??
          {};
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      saveLastMessage();
    }
  }

  @override
  void dispose() {
    // print('disposing');
    socketService.socket
        ?.off('receive_unread_message', _onReceiveUnreadMessage);
    socketService.socket?.off('receive_last_message', _onReceiveLastMessage);
    saveLastMessage();
    WidgetsBinding.instance.removeObserver(this);
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
          // print(snapshot.data);
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 60, bottom: 65),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                // listIsReadMessages =
                //     List.generate(snapshot.data!.length, (index) => );
                // return Container(color: Colors.amber);
                return InkWell(
                  splashColor: Colors.grey.shade200,
                  onTap: () {
                    setState(() {
                      lastMessages[snapshot.data![index].roomId]?['isRead'] =
                          'true';
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          roomId: snapshot.data![index].roomId,
                          romName: snapshot.data![index].nameRoom,
                          urlImageUserReceive: snapshot.data![index].image,
                        ),
                      ),
                    );
                  },
                  child: RoomChatWidget(
                    urlImage: snapshot.data![index].image,
                    title: snapshot.data![index].nameRoom,
                    unreadMessage: lastMessages[snapshot.data![index].roomId]
                            ?['text'] ??
                        '',
                    isUnread: bool.parse(
                        lastMessages[snapshot.data![index].roomId]?['isRead'] ??
                            'true'),
                  ),
                );
              },
            );
          }
          return const WidgetLoading();
        },
      ),
    );
  }
}
