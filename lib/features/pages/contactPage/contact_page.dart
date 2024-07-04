import 'package:chat_app/features/pages/contactPage/widgets/add_friend_widget.dart';
import 'package:chat_app/models/accout_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'viewModels/contact_page_view_models.dart';
import 'widgets/friend_request_widget.dart';
import 'widgets/friend_widget.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  var contactPageViewModels = ContactPageViewModels();
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 55, bottom: 65),
      width: sizeScreen.width,
      height: sizeScreen.height,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black12)),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: contactPageViewModels.getFriendsRequest(currentUser!.uid),
              builder: (context, snapshot) {
                // print(snapshot.data);
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Text(
                              'Lời mời',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                '${snapshot.data!.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: sizeScreen.height * 0.40,
                          minHeight: 10,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) => Column(
                            children: [
                              const SizedBox(height: 12),
                              FriendRequestWidget(
                                  friendRequestModel: snapshot.data![index]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),

            const SizedBox(height: 12),
            // ----

            SizedBox(
              height: sizeScreen.height,
              child: StreamBuilder(
                stream: contactPageViewModels.getFriends(currentUser!.uid),
                builder: (context, snapshot) {
                  // print(snapshot.data);
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'Bạn bè',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return FriendWidget(user: snapshot.data![index]);
                            }),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
