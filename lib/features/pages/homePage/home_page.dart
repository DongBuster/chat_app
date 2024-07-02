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

  Map<String, Map<String, dynamic>> unreadMessages = {};
  // List<bool> listIsReadMessages = [];
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    socketService.socket?.on('receive_unread_message', _onReceiveUnreadMessage);
    intialUnreadMessage();
    super.initState();
  }

  void _onReceiveUnreadMessage(data) {
    MessageModel messageModel = MessageModel.fromJson(data);

    setState(() {
      bool exit = false;

      for (var key in unreadMessages.keys) {
        if (key == messageModel.roomId) {
          unreadMessages[messageModel.roomId]?['text'] = messageModel.text;
          unreadMessages[messageModel.roomId]?['isRead'] = 'false';
          exit = true;
          break;
        }
      }
      if (exit == false) {
        unreadMessages[messageModel.roomId] = {
          'text': messageModel.text,
          'isRead': 'false'
        };
      }

      // print(unreadMessages);
    });
  }

  void saveUnreadMessage() {
    final db = Localstore.instance;
    db.collection('message').doc('unreadMessage').set(unreadMessages);
  }

  Future<void> intialUnreadMessage() async {
    final db = Localstore.instance;
    final data = await db.collection('message').doc('unreadMessage').get();
    // print('data save :$data');
    setState(() {
      unreadMessages = data?.map(
              (key, value) => MapEntry(key, value as Map<String, dynamic>)) ??
          {};
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      saveUnreadMessage();
    }
  }

  @override
  void dispose() {
    socketService.socket
        ?.off('receive_unread_message', _onReceiveUnreadMessage);
    saveUnreadMessage();
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
          // print(snapshot.data![0].nameRoom);
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 60, bottom: 65),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                // listIsReadMessages =
                //     List.generate(snapshot.data!.length, (index) => );
                return InkWell(
                  splashColor: Colors.grey.shade200,
                  onTap: () {
                    setState(() {
                      unreadMessages[snapshot.data![index].id]?['isRead'] =
                          'true';
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          roomId: snapshot.data![index].id,
                          romName: snapshot.data![index].nameRoom,
                          urlImageUserReceive: snapshot.data![index].image,
                        ),
                      ),
                    );
                  },
                  child: RoomChatWidget(
                    urlImage: snapshot.data![index].image,
                    title: snapshot.data![index].nameRoom,
                    unreadMessage:
                        unreadMessages[snapshot.data![index].id]?['text'] ?? '',
                    isUnread: bool.parse(
                        unreadMessages[snapshot.data![index].id]?['isRead'] ??
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
