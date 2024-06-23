import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/auth/services/auth.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidthDevice = MediaQuery.of(context).size.width;
    return Drawer(
      width: screenWidthDevice * 0.8,
      // shape: ,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Item 1'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          TextButton(
              onPressed: () async {
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
              child: const Text('logout'))
        ],
      ),
    );
  }
}
