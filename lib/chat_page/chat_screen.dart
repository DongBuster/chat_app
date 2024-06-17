import 'package:chat_app/server/socket_service.dart';
import 'package:flutter/material.dart';
import 'widgets/received_message_bubble.dart';
import 'widgets/sent_message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserName;
  final String romName;
  const ChatScreen({
    super.key,
    required this.currentUserName,
    required this.romName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  var socketService = SocketService();
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

    socketService.joinRoom(widget.romName);
    socketService.socket?.on('receive_message', (data) {
      setState(() {
        messages.add(ReceiveMessageBubble(message: data));
      });
      scrollToEnd();
    });

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    socketService.leaveRoom(widget.romName);
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

  void sendMessage(String message) {
    // final Messages messages = Messages(senderID: widget.currentUserName, receiverID: , message: message)
    if (message.isNotEmpty) {
      socketService.sendMessage(
          widget.currentUserName, widget.romName, message);
      setState(() {
        messages.add(SentMessageBubble(message: message));
        isShowButtonToScrollEnd = false;

        scrollToEnd();
      });

      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    // print(scrollController.position.pixels);
    // print(scrollController.position.isScrollingNotifier.value);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        leading: IconButton(
          onPressed: () {
            WidgetsBinding.instance.removeObserver(this);
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 25,
            color: Colors.white,
          ),
        ),
        title: const Text('chat'),
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
                  padding: const EdgeInsets.only(bottom: 60),
                  itemCount: messages.length,
                  itemBuilder: (context, index) => messages[index],
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
