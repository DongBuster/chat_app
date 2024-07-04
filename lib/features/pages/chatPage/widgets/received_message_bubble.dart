import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ReceiveMessageBubble extends StatelessWidget {
  final String text;
  final String urlImageUser;
  const ReceiveMessageBubble({
    super.key,
    required this.text,
    required this.urlImageUser,
  });

  @override
  Widget build(BuildContext context) {
    // print(messageModel.text);
    return Row(
      children: [
        const SizedBox(width: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: urlImageUser == '' || urlImageUser == 'null'
              ? Image.asset(
                  'assets/user_default.jpg',
                  width: 25,
                  height: 25,
                )
              : CachedNetworkImage(
                  width: 25,
                  height: 25,
                  imageUrl: urlImageUser,
                ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.45,
                minWidth: 35),
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
        ),
      ],
    );
  }
}
