import 'package:flutter/material.dart';

class SentMessageBubble extends StatelessWidget {
  final String message;
  const SentMessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.45, minWidth: 35),
        child: Container(
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 12, right: 12),
          margin: const EdgeInsets.only(top: 5, bottom: 5, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.blue.shade300,
          ),
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
