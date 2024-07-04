import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/features/pages/contactPage/widgets/add_friend_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/accout_user.dart';
import '../viewModels/contact_page_view_models.dart';

class AddFriendsScreen extends StatefulWidget {
  const AddFriendsScreen({super.key});

  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  var contactPageViewModel = ContactPageViewModels();
  User? currentUser = FirebaseAuth.instance.currentUser;

  final _focusNode = FocusNode();
  final _controllerSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back, size: 22, color: Colors.blue),
        ),
        title: Text(
          'Thêm bạn bè',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.blue.withOpacity(0.75),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(height: 1, width: sizeScreen.width, color: Colors.black12),
          const SizedBox(height: 12),
          SizedBox(
            width: sizeScreen.width - 50,
            height: 35,
            child: TextField(
              focusNode: _focusNode,
              controller: _controllerSearch,
              onChanged: (value) {
                setState(() {
                  _controllerSearch.text = value;
                });
              },
              onTapOutside: (event) {
                _focusNode.unfocus();
              },
              cursorHeight: 20,
              decoration: InputDecoration(
                //
                prefixIcon: Icon(
                  Icons.search,
                  size: 22,
                  color: Colors.grey.shade400,
                ),
                //
                contentPadding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                hintText: 'Nhập tên bạn bè',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                //
                filled: true,
                fillColor: Colors.grey.shade200,
                //
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 22, top: 12),
              child: Text(
                'Gợi ý',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          _controllerSearch.text.isEmpty
              ? FutureBuilder(
                  future: contactPageViewModel.streamListUser(currentUser!.uid),
                  builder: (context, snapshot) {
                    // print(snapshot.data);

                    if (snapshot.hasData) {
                      // print(snapshot.data);
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            AccoutUser user = snapshot.data![index];
                            return AddFriendWidget(user: user);
                          },
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                )
              : StreamBuilder(
                  stream: contactPageViewModel
                      .searchNameUser(_controllerSearch.text),
                  builder: (context, snapshot) {
                    // print(snapshot.data);

                    if (snapshot.hasData) {
                      // print(snapshot.data);
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            AccoutUser user = snapshot.data![index];
                            return AddFriendWidget(user: user);
                          },
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
        ],
      ),
    );
  }
}
