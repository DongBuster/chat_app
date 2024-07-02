import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/button_icon.dart';

class HeaderContactPage extends StatelessWidget {
  const HeaderContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Bạn bè',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          ButtonIcon(
            func: () {
              context.push('/contactPage/addFriendsScreen');
            },
            icon: Icons.add,
          ),
        ],
      ),
    );
  }
}
