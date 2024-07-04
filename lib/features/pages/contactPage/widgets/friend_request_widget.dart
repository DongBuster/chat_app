// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/features/pages/contactPage/viewModels/contact_page_view_models.dart';
import 'package:flutter/material.dart';
import '../models/friends_request_model.dart';

class FriendRequestWidget extends StatefulWidget {
  final FriendRequestModel friendRequestModel;
  const FriendRequestWidget({
    super.key,
    required this.friendRequestModel,
  });

  @override
  State<FriendRequestWidget> createState() => _FriendRequestWidgetState();
}

class _FriendRequestWidgetState extends State<FriendRequestWidget> {
  var contactPageViewModels = ContactPageViewModels();
  bool isAccept = false;
  bool isRefuse = false;

  @override
  Widget build(BuildContext context) {
    // print(isAccept);
    return Row(
      children: [
        FutureBuilder(
          future: contactPageViewModels
              .getUrlImageUser(widget.friendRequestModel.senderId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: snapshot.data == ''
                    ? Image.asset(
                        'assets/user_default.jpg',
                        width: 40,
                        height: 40,
                      )
                    : CachedNetworkImage(
                        width: 60,
                        height: 60,
                        imageUrl: snapshot.data!,
                      ),
              );
            }
            return const SizedBox();
          },
        ),
        const SizedBox(width: 12),
        FutureBuilder(
          future: contactPageViewModels
              .getNameUser(widget.friendRequestModel.senderId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.data!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  isAccept
                      ? Container(
                          width: 170,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: const Center(
                            child: Text(
                              'Đã chấp nhận lời mời...',
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  isRefuse
                      ? Container(
                          width: 150,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: const Center(
                            child: Text(
                              'Đã từ chối lời mời...',
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  !isAccept && !isRefuse
                      ? Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isAccept = true;
                                });
                                contactPageViewModels.acceptFriendRequest(
                                    widget.friendRequestModel);
                              },
                              splashColor: Colors.grey.shade300,
                              child: Container(
                                width: 90,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade700,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Chấp nhận',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isRefuse = true;
                                });
                              },
                              splashColor: Colors.grey.shade300,
                              child: Container(
                                width: 90,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Xóa',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox()
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
