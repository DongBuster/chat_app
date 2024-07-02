import 'package:chat_app/features/pages/homePage/views/create_group_chat.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/button_icon.dart';

class HeaderHomePage extends StatelessWidget {
  const HeaderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Đoạn chat',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          ButtonIcon(
            func: () {
              context.push('/homePage/createGroupChat');
            },
            icon: Icons.edit,
          ),
        ],
      ),
    );
  }
}
