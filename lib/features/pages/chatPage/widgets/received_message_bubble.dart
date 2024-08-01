import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/features/pages/chatPage/chatPageViewModel/chat_page_view_model.dart';
import 'package:flutter/material.dart';

class ReceiveMessageBubble extends StatelessWidget {
  final String text;
  final String userId;
  const ReceiveMessageBubble({
    super.key,
    required this.text,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    // print(urlImageUser);
    return Row(
      children: [
        const SizedBox(width: 8),
        FutureBuilder(
            future: ChatPageViewModel.getUrlImageUser(userId),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != '') {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    width: 25,
                    height: 25,
                    imageUrl: snapshot.data!,
                  ),
                );
              }
              return ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'assets/user_default.jpg',
                    width: 25,
                    height: 25,
                  ));
            }),
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
