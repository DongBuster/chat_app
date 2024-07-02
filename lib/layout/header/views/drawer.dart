import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/auth/services/auth.dart';
import '../widgets/card_item.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // getUrlImageUser(currentUser?.uid ?? '');
    // getNameUser()
    super.initState();
  }

  Future<String> getUrlImageUser(String userId) async {
    String urlImage = '';
    if (userId == '') {
      return '';
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((result) {
      Map<String, dynamic> data = result.data() as Map<String, dynamic>;
      if (data['image'] == 'null') {
        return '';
      } else {
        urlImage = data['image'];
      }
    }).catchError((err) {
      return '';
    });
    return urlImage;
  }

  Future<String> getNameUser(String userId) async {
    String name = '';
    if (userId == '') {
      return '';
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((result) {
      Map<String, dynamic> data = result.data() as Map<String, dynamic>;
      if (data['name'] == 'null') {
        return '';
      } else {
        name = data['name'];
      }
    }).catchError((err) {
      return '';
    });
    return name;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidthDevice = MediaQuery.of(context).size.width;

    return Drawer(
      width: screenWidthDevice * 0.8,
      // shape: ,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  FutureBuilder(
                    future: getUrlImageUser(currentUser?.uid ?? ''),
                    builder: (context, snapshot) {
                      // print(snapshot.data);
                      // print(1);
                      if (snapshot.hasData) {
                        return snapshot.data == ''
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  'assets/user_default.jpg',
                                  width: 55,
                                  height: 55,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data!,
                                  height: 55,
                                  width: 55,
                                ),
                              );
                      }

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          'assets/user_default.jpg',
                          width: 55,
                          height: 55,
                        ),
                      );

                      // return const SizedBox();
                    },
                  ),
                  const SizedBox(width: 12),
                  FutureBuilder(
                    future: getNameUser(currentUser?.uid ?? ''),
                    builder: (context, snapshot) {
                      // print(snapshot.data);
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        );
                      }
                      return const Text(
                        'Unkown user',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      );
                    },
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.settings,
                  size: 25,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const CardItem(
            icon: Icons.message_outlined,
            title: 'Đoạn chat',
            isUnview: true,
            numberUnview: 2,
            isSelected: true,
          ),
          const CardItem(
            icon: Icons.shopping_bag_outlined,
            title: 'Marketplace',
            isUnview: false,
            numberUnview: 0,
            isSelected: false,
          ),
          const CardItem(
            icon: Icons.contrast,
            title: 'Theme',
            isUnview: false,
            numberUnview: 0,
            isSelected: false,
          ),
          InkWell(
            splashColor: Colors.grey.shade200,
            onTap: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();

              await Auth.signOut().then((value) async {
                await prefs.setBool('islogin', false);
                await prefs.setString('email', '');
                if (context.mounted) {
                  context.go('/login');
                }
              });
            },
            child: const CardItem(
              icon: Icons.logout_rounded,
              title: 'Logout',
              isUnview: false,
              numberUnview: 0,
              isSelected: false,
            ),
          ),
        ],
      ),
    );
  }
}
