// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RoomChatWidget extends StatefulWidget {
  final String title;
  final String urlImage;
  bool isUnread;
  String unreadMessage;
  RoomChatWidget({
    super.key,
    required this.title,
    required this.urlImage,
    required this.isUnread,
    required this.unreadMessage,
  });

  @override
  State<RoomChatWidget> createState() => _RoomChatWidgetState();
}

class _RoomChatWidgetState extends State<RoomChatWidget> {
  @override
  Widget build(BuildContext context) {
    // print(widget.urlImage);
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: widget.urlImage == '' || widget.urlImage == 'null'
            ? Image.asset(
                'assets/user_default.jpg',
                width: 55,
                height: 55,
              )
            : CachedNetworkImage(
                width: 55,
                height: 55,
                imageUrl: widget.urlImage,
              ),
      ),
      title: Text(
        widget.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
      subtitle: widget.isUnread == false
          ? Text(
              widget.unreadMessage,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black87,
              ),
            )
          : Text(
              widget.unreadMessage,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black38,
              ),
            ),
      trailing: widget.isUnread == false
          ? const Icon(
              Icons.circle,
              size: 12,
              color: Colors.blue,
            )
          : const SizedBox(),
    );
  }
}
