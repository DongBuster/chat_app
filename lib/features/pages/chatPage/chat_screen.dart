import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:chat_app/features/pages/chatPage/models/message_model.dart';
import 'package:chat_app/server/socket_service.dart';

import 'chatPageViewModel/chat_page_view_model.dart';
import 'widgets/received_message_bubble.dart';
import 'widgets/sent_message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final String romName;
  final String urlImageRoom;
  const ChatScreen({
    super.key,
    required this.roomId,
    required this.romName,
    required this.urlImageRoom,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  var socketService = SocketService();
  var chatPageViewModel = ChatPageViewModel();

  User? currentUser = FirebaseAuth.instance.currentUser;

  List<Widget> messages = [];

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  final controller = TextEditingController();
  final controller2 = TextEditingController();

  final myFocusNode = FocusNode();
  final myFocusNode2 = FocusNode();

  bool isHideInput = true;
  bool isShowButtonToScrollEnd = false;
  bool isUserScrolling = false;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    loadInitialMessage();

    socketService.joinRoom(widget.roomId);
    socketService.socket?.on('receive_message', _onReceiveMessage);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    socketService.leaveRoom(widget.roomId);
    socketService.socket?.off('receive_message', _onReceiveMessage);
    myFocusNode.unfocus();
    myFocusNode2.unfocus();
    scrollController.dispose();
    messageController.dispose();
    controller.dispose();
    controller2.dispose();
    super.dispose();
  }

  void scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (messages.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (MediaQuery.of(context).viewInsets.bottom > 0) {
          scrollToEnd();
        }
      });
    }
  }

  void _onReceiveMessage(data) async {
    // print(MessageModel.fromJson(data).senderId);
    setState(() {
      messages.add(
        ReceiveMessageBubble(
            userId: MessageModel.fromJson(data).senderId,
            text: MessageModel.fromJson(data).text),
      );
    });
    scrollToEnd();
  }

  MessageModel generateMessageModel(String messageText) {
    final DateFormat formatter = DateFormat('HH:mm:ss dd/MM/yyyy');
    final String timeNow = formatter.format(DateTime.now());

    String id = const Uuid().v1();

    List<String> userIdRoom = widget.roomId.split('_');
    List<String> receivedId =
        userIdRoom.where((element) => element != currentUser!.uid).toList();

    return MessageModel(
      id: id,
      roomId: widget.roomId,
      text: messageText,
      senderId: currentUser?.uid ?? '',
      receivedId: receivedId,
      time: timeNow,
    );
  }

  void sendMessage(String messageText) {
    var messageModel = generateMessageModel(messageText);
    // print(messageModel.roomId);
    if (messageText.isNotEmpty) {
      socketService.sendMessage(messageModel);
      setState(() {
        messages.add(SentMessageBubble(text: messageText));
        chatPageViewModel.pushData(messageModel);
        isShowButtonToScrollEnd = false;
        scrollToEnd();
      });

      messageController.clear();
    }
  }

  Future<void> loadInitialMessage() async {
    var initialMessage = await chatPageViewModel.getMessages(widget.roomId);

    setState(() {
      for (var message in initialMessage) {
        if (currentUser!.uid == message.senderId &&
            message.roomId == widget.roomId) {
          messages.add(SentMessageBubble(text: message.text));
        } else {
          messages.add(ReceiveMessageBubble(
              userId: message.senderId, text: message.text));
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    // print(currentUser!.uid);
    // print(scrollController.position.pixels);
    // print(scrollController.position.isScrollingNotifier.value);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 25,
            color: Colors.white,
          ),
        ),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: widget.urlImageRoom == '' || widget.urlImageRoom == 'null'
                  ? Image.asset(
                      'assets/user_default.jpg',
                      width: 45,
                      height: 45,
                    )
                  : CachedNetworkImage(
                      width: 45,
                      height: 45,
                      imageUrl: widget.urlImageRoom,
                    ),
            ),
            const SizedBox(width: 14),
            Text(
              widget.romName,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              myFocusNode.unfocus();
              myFocusNode2.unfocus();
              controller.text = controller2.text;
              isHideInput = true;
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  // print('notification:$isUserScrolling');

                  if (notification.metrics.axis == Axis.vertical) {
                    if (notification.metrics.pixels <
                        (notification.metrics.maxScrollExtent - 150)) {
                      setState(() {
                        isShowButtonToScrollEnd = true;
                      });
                    }
                    if (notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                      setState(() {
                        isShowButtonToScrollEnd = false;
                      });
                    }
                  }
                  return false;
                },
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.only(bottom: 65, top: 10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        messages.isEmpty ? const SizedBox() : messages[index],
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          isShowButtonToScrollEnd
              ? Positioned(
                  bottom: 70,
                  left: screenWidth * 0.48,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isShowButtonToScrollEnd = false;
                        scrollToEnd();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey.shade200,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.arrow_downward_rounded,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  height: 60,
                  width: screenWidth,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 20,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.image,
                          size: 20,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.mic_rounded,
                          size: 20,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        width: screenWidth - 160,
                        height: 40,
                        child: TextField(
                          controller: controller,
                          onChanged: (value) => setState(() {
                            myFocusNode2.requestFocus();
                            controller2.text = value;
                            isHideInput = !isHideInput;
                          }),
                          onTap: () => setState(() {
                            myFocusNode2.requestFocus();
                            isHideInput = !isHideInput;
                          }),
                          cursorColor: Colors.blue,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                          ),
                          focusNode: myFocusNode,
                          decoration: InputDecoration(
                            suffixIcon: const Icon(
                              Icons.tag_faces,
                              color: Colors.blue,
                              size: 22,
                            ),
                            hintText: 'Nhắn tin',
                            hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding:
                                const EdgeInsets.only(left: 15, right: 10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.thumb_up,
                          size: 20,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                isHideInput
                    ? const SizedBox()
                    : Positioned(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              color: Colors.white,
                              width: screenWidth,
                              height: 60,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: IconButton(
                                              onPressed: () => setState(() {
                                                myFocusNode.requestFocus();
                                                controller.text =
                                                    controller2.text;
                                                isHideInput = !isHideInput;
                                              }),
                                              icon: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 20,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 800),
                                            width: (screenWidth - 160) + 80,
                                            height: 40,
                                            child: TextField(
                                              controller: controller2,
                                              focusNode: myFocusNode2,
                                              cursorColor: Colors.blue,
                                              onChanged: (value) {
                                                // print(value.isEmpty);
                                                if (value.isEmpty) {
                                                  setState(() {
                                                    isHideInput = true;
                                                    controller.clear();
                                                    controller2.clear();
                                                  });
                                                }
                                              },
                                              onSubmitted: (value) {
                                                if (controller2
                                                    .text.isNotEmpty) {
                                                  sendMessage(controller2.text);
                                                  controller2.clear();
                                                  controller.clear();
                                                  isHideInput = true;
                                                  myFocusNode.requestFocus();
                                                }
                                              },
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.7),
                                                fontWeight: FontWeight.w500,
                                                decoration: TextDecoration.none,
                                              ),
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                suffixIcon: const Icon(
                                                  Icons.tag_faces,
                                                  color: Colors.blue,
                                                  size: 22,
                                                ),
                                                hintText: 'Nhắn tin',
                                                hintStyle: const TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                filled: true,
                                                fillColor: Colors.grey.shade100,
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 15, right: 10),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: IconButton(
                                          onPressed: () {
                                            if (controller2.text.isNotEmpty) {
                                              sendMessage(controller2.text);

                                              controller2.clear();
                                              controller.clear();
                                            }
                                            setState(() {
                                              isHideInput = true;
                                              myFocusNode.requestFocus();
                                              // myFocusNode.requestFocus();
                                              // myFocusNode2.unfocus();
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.send,
                                            size: 20,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
