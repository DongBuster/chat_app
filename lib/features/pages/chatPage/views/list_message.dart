// import 'package:chat_app/features/pages/chatPage/widgets/received_message_bubble.dart';
// import 'package:chat_app/features/pages/chatPage/widgets/sent_message_bubble.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/widgets.dart';

// import 'package:chat_app/features/pages/chatPage/models/message_model.dart';

// class ViewMessage extends StatefulWidget {
//   final MessageModel messageModel;
//   const ViewMessage({
//     Key? key,
//     required this.messageModel,
//   }) : super(key: key);

//   @override
//   State<ViewMessage> createState() => _ViewMessageState();
// }

// class _ViewMessageState extends State<ViewMessage> {
//   User? currentUser = FirebaseAuth.instance.currentUser;
//   @override
//   Widget build(BuildContext context) {
//     currentUser!.uid == widget.messageModel.senderId ?  SentMessageBubble(message: widget.messageModel.text) : ReceiveMessageBubble(text: widget.messageModel.text);
  
//   }
// }