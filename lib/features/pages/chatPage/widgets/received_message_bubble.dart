// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:chat_app/features/pages/chatPage/models/message_model.dart';

class ReceiveMessageBubble extends StatelessWidget {
  final String text;
  const ReceiveMessageBubble({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    // print(messageModel.text);
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.45, minWidth: 35),
        child: Container(
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 12, right: 12),
          margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade200,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }
}
