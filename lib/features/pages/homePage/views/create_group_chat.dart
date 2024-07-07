// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/features/pages/contactPage/models/friend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:chat_app/features/pages/homePage/views/test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../models/accout_user.dart';
import '../widgets/input_chip.dart';

class CreateGroupChat extends StatefulWidget {
  const CreateGroupChat({super.key});

  @override
  State<CreateGroupChat> createState() => _CreateGroupChatState();
}

class _CreateGroupChatState extends State<CreateGroupChat> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.grey,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_outlined,
              size: 22, color: Colors.black),
        ),
        title: const Text(
          'Tạo nhóm chat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text(
                    'Tên nhóm: ',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 20,
                    width: screenWidth * 0.55,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Tên nhóm của bạn',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 9,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // const Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: Row(
            //     children: [
            //       Text(
            //         'Thành viên: ',
            //         style: TextStyle(
            //           fontSize: 16,
            //           color: Colors.grey,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //       SizedBox(width: 8),
            //     ],
            //   ),
            // ),
            const Expanded(child: EditableChipFieldExample()),

            // const SizedBox(height: 15),
            // Align(
            //   alignment: Alignment.center,
            //   child: Container(
            //     height: 35,
            //     width: 120,
            //     decoration: BoxDecoration(
            //       gradient: const LinearGradient(
            //         colors: [
            //           Color(0xFFd9a5b3), // Light Blue
            //           Color(0xFF1868ae), // Greenink Purple
            //           Color(0xFFc6d7eb), // Greenink Purple
            //         ],
            //         begin: Alignment.topLeft,
            //         end: Alignment.bottomRight,
            //       ),
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     child: const Center(
            //       child: Text(
            //         'Hoàn thành',
            //         style: TextStyle(
            //           fontSize: 16,
            //           color: Colors.white,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            // const Padding(
            //   padding: EdgeInsets.all(8),
            //   child: Text(
            //     'Gợi ý',
            //     style: TextStyle(
            //       fontSize: 16,
            //       color: Colors.grey,
            //       fontWeight: FontWeight.w500,
            //     ),
            //   ),
            // ),
            // ListView.builder(itemBuilder: itemBuilder)
          ],
        ),
      ),
    );
  }
}

class EditableChipFieldExample extends StatefulWidget {
  const EditableChipFieldExample({super.key});

  @override
  EditableChipFieldExampleState createState() {
    return EditableChipFieldExampleState();
  }
}

class EditableChipFieldExampleState extends State<EditableChipFieldExample> {
  final FocusNode _chipFocusNode = FocusNode();
  List<FriendsModel> _toppings = [];
  List<FriendsModel> _suggestions = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Thành viên: ',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: ChipsInput<FriendsModel>(
                values: _toppings,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 9),
                  hintText: 'Tên bạn bè',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  focusedBorder:
                      const OutlineInputBorder(borderSide: BorderSide.none),
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                ),
                strutStyle: const StrutStyle(fontSize: 15),
                onChanged: _onChanged,
                onSubmitted: _onSubmitted,
                chipBuilder: _chipBuilder,
                onTextChanged: _onSearchChanged,
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            height: 35,
            width: 90,
            decoration: BoxDecoration(
              // gradient: const LinearGradient(
              //   colors: [
              //     Color(0xFFd9a5b3), // Light Blue
              //     Color(0xFF1868ae), // Greenink Purple
              //     Color(0xFFc6d7eb), // Greenink Purple
              //   ],
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              // ),
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Tạo',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        if (_suggestions.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: _suggestions.length,
              itemBuilder: (BuildContext context, int index) {
                return ToppingSuggestion(
                  _suggestions[index],
                  onTap: _selectSuggestion,
                );
              },
            ),
          )
      ],
    );
  }

  Future<void> _onSearchChanged(String value) async {
    firebase_auth.User? currentUser =
        firebase_auth.FirebaseAuth.instance.currentUser;
    final List<FriendsModel> results =
        await _suggestionCallback(value, currentUser!.uid);
    setState(() {
      _suggestions = results
          .where((FriendsModel topping) => !_toppings.contains(topping))
          .toList();
    });
  }

  Widget _chipBuilder(BuildContext context, FriendsModel topping) {
    return ToppingInputChip(
      topping: topping,
      onDeleted: _onChipDeleted,
      onSelected: _onChipTapped,
    );
  }

  void _selectSuggestion(FriendsModel topping) {
    setState(() {
      _toppings.add(topping);
      _suggestions = [];
    });
  }

  void _onChipTapped(FriendsModel topping) {}

  void _onChipDeleted(FriendsModel topping) {
    setState(() {
      _toppings.remove(topping);
      _suggestions = [];
    });
  }

  void _onSubmitted(String text) {
    if (text.trim().isNotEmpty) {
      setState(() {
        _toppings = [..._toppings];
      });
    } else {
      _chipFocusNode.unfocus();
      setState(() {
        _toppings = [];
      });
    }
  }

  void _onChanged(List<FriendsModel> data) {
    setState(() {
      _toppings = data;
    });
  }

  FutureOr<List<FriendsModel>> _suggestionCallback(
      String text, String currentUserId) async {
    List<FriendsModel> listFriend = [];
    if (text.isNotEmpty) {
      await Supabase.instance.client
          .from('friends')
          .select('nameFriend,imageFriend,idFriend')
          .eq('userId', currentUserId)
          .then((listData) {
        for (var element in listData) {
          var friend = FriendsModel.fromJson(element);
          if (friend.nameFriend.contains(text)) {
            listFriend.add(friend);
          }
        }
      });
      return listFriend;
    }
    return [];
  }
}

class ToppingSuggestion extends StatelessWidget {
  const ToppingSuggestion(this.topping, {super.key, this.onTap});

  final FriendsModel topping;
  final ValueChanged<FriendsModel>? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // key: ObjectKey(topping,),
      leading: CircleAvatar(
        child: topping.imageFriend == 'null' || topping.imageFriend == ''
            ? Image.asset(
                'assets/user_default.jpg',
                width: 45,
                height: 45,
              )
            : CachedNetworkImage(
                width: 45,
                height: 45,
                imageUrl: topping.imageFriend,
              ),
      ),
      title: Text(topping.nameFriend),
      onTap: () => onTap?.call(topping),
    );
  }
}

class ToppingInputChip extends StatelessWidget {
  const ToppingInputChip({
    super.key,
    required this.topping,
    required this.onDeleted,
    required this.onSelected,
  });

  final FriendsModel topping;
  final ValueChanged<FriendsModel> onDeleted;
  final ValueChanged<FriendsModel> onSelected;

  @override
  Widget build(BuildContext context) {
    // print(topping.imageFriend);
    return Container(
      margin: const EdgeInsets.only(right: 3),
      child: InputChip(
        backgroundColor: Colors.grey.shade200,
        labelPadding: const EdgeInsets.all(1),
        side: BorderSide.none,
        deleteIcon: const Icon(
          Icons.cancel_outlined,
          color: Colors.black,
          size: 16,
        ),
        label: Text(
          topping.nameFriend,
          style: const TextStyle(fontSize: 12),
        ),
        avatar: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: topping.imageFriend == 'null' || topping.imageFriend == ''
              ? Image.asset(
                  'assets/user_default.jpg',
                  width: 45,
                  height: 45,
                )
              : CachedNetworkImage(
                  width: 45,
                  height: 45,
                  imageUrl: topping.imageFriend,
                ),
        ),
        onDeleted: () => onDeleted(topping),
        onSelected: (bool value) => onSelected(topping),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
