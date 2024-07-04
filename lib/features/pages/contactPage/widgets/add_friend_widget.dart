// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/features/pages/contactPage/models/friends_request_model.dart';
import 'package:chat_app/features/pages/contactPage/viewModels/contact_page_view_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/models/accout_user.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class AddFriendWidget extends StatefulWidget {
  final AccoutUser user;
  const AddFriendWidget({
    super.key,
    required this.user,
  });

  @override
  State<AddFriendWidget> createState() => _AddFriendWidgetState();
}

class _AddFriendWidgetState extends State<AddFriendWidget> {
  var contactPageViewModel = ContactPageViewModels();

  User? currentUser = FirebaseAuth.instance.currentUser;
  bool isAddFriend = false;

  @override
  Widget build(BuildContext context) {
    // print(user?.uid ?? '');
    return InkWell(
      splashColor: Colors.grey.shade300,
      onTap: () {
        final DateFormat formatter = DateFormat('HH:mm:ss dd/MM/yyyy');
        final String timeNow = formatter.format(DateTime.now());
        var friendRequestModel = FriendRequestModel(
          id: '${currentUser!.uid}_${widget.user.id}',
          senderId: currentUser!.uid,
          receiverId: widget.user.id,
          status: 'pending',
          sentAt: timeNow,
        );
        setState(() {
          isAddFriend = !isAddFriend;
        });
        contactPageViewModel.sentFriendRequest(friendRequestModel);
      },
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
                      child: widget.user.image == 'null'
                          ? Image.asset(
                              'assets/user_default.jpg',
                              width: 45,
                              height: 45,
                            )
                          : CachedNetworkImage(
                              width: 45,
                              height: 45,
                              imageUrl: widget.user.image,
                            ),
                    ),
                    widget.user.isOnline == 'false'
                        ? const SizedBox()
                        : Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                              child: const Icon(Icons.circle,
                                  size: 13, color: Colors.green),
                            ),
                          ),
                  ],
                ),
                const SizedBox(width: 12),
                Text(
                  widget.user.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.75),
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                final DateFormat formatter = DateFormat('HH:mm:ss dd/MM/yyyy');
                final String timeNow = formatter.format(DateTime.now());
                var friendRequestModel = FriendRequestModel(
                  id: '${currentUser!.uid}_${widget.user.id}',
                  senderId: currentUser!.uid,
                  receiverId: widget.user.id,
                  status: 'pending',
                  sentAt: timeNow,
                );
                setState(() {
                  isAddFriend = !isAddFriend;
                });
                contactPageViewModel.sentFriendRequest(friendRequestModel);
              },
              icon: isAddFriend == false
                  ? Icon(
                      Icons.person_add_alt_1_outlined,
                      size: 22,
                      color: Colors.blue.withOpacity(0.75),
                    )
                  : ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          Colors.blue.withOpacity(0.75), BlendMode.srcATop),
                      child: SvgPicture.asset(
                        'assets/icon_svg/person_check.svg',
                        width: 22,
                        height: 22,
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
