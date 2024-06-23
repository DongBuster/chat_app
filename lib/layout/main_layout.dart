import 'package:chat_app/layout/footer/footer.dart';
import 'package:flutter/material.dart';

import 'header/header.dart';
import 'header/views/drawer.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            child,
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Header(),
            ),
            const Positioned(bottom: 0, left: 0, right: 0, child: Footer()),
          ],
        ),
        drawerScrimColor: Colors.black.withOpacity(0.1),
        drawer: const DrawerScreen(),
      ),
    );
  }
}
