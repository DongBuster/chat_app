// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/features/pages/contactPage/models/friend.dart';
import 'package:chat_app/features/pages/contactPage/models/friends_request_model.dart';
import 'package:chat_app/features/pages/contactPage/viewModels/contact_page_view_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/accout_user.dart';
import 'package:intl/intl.dart';

class FriendWidget extends StatefulWidget {
  final FriendsModel user;
  const FriendWidget({
    super.key,
    required this.user,
  });

  @override
  State<FriendWidget> createState() => _FriendWidgetState();
}

class _FriendWidgetState extends State<FriendWidget> {
  var contactPageViewModel = ContactPageViewModels();

  User? currentUser = FirebaseAuth.instance.currentUser;
  bool isAddFriend = false;

  @override
  Widget build(BuildContext context) {
    // print(user?.uid ?? '');
    return InkWell(
      splashColor: Colors.grey.shade300,
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: widget.user.imageFriend == 'null' ||
                              widget.user.imageFriend == ''
                          ? Image.asset(
                              'assets/user_default.jpg',
                              width: 45,
                              height: 45,
                            )
                          : CachedNetworkImage(
                              width: 45,
                              height: 45,
                              imageUrl: widget.user.imageFriend,
                            ),
                    ),
                    StreamBuilder(
                      stream:
                          contactPageViewModel.streamUser(widget.user.idFriend),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // print(snapshot.data!.isOnline);
                          return snapshot.data!.isOnline == 'false'
                              ? const SizedBox()
                              : Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.circle,
                                      size: 13,
                                      color: Colors.green,
                                    ),
                                  ),
                                );
                        }
                        return const SizedBox();
                      },
                    )
                  ],
                ),
                const SizedBox(width: 12),
                Text(
                  widget.user.nameFriend,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
