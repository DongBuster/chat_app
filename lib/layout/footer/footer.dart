import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:go_router/go_router.dart';
import 'widgets/icon_button.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> with TickerProviderStateMixin {
  late AnimationController _homeController;
  late AnimationController _contactController;
  late AnimationController _newsController;

  @override
  void initState() {
    _homeController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _contactController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _newsController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    _homeController.dispose();
    _contactController.dispose();
    _newsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String nameRoute = GoRouterState.of(context).uri.toString();

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade100,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 3,
              blurRadius: 3,
            ),
          ]),
      padding: const EdgeInsets.only(top: 12, bottom: 8, left: 18, right: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              context.go('/homePage');
            },
            child: IconButtonFooter(
              controller: _homeController,
              icons: Icons8.home_2,
              namePage: 'Home',
              color: nameRoute == '/homePage' ? Colors.blue : Colors.black,
            ),
          ),
          GestureDetector(
            onTap: () {
              context.go('/contactPage');
            },
            child: IconButtonFooter(
              controller: _contactController,
              icons: Icons8.people,
              namePage: 'Danh bạ',
              color: nameRoute == '/contactPage' ? Colors.blue : Colors.black,
            ),
          ),
          GestureDetector(
            onTap: () {
              context.go('/newsPage');
            },
            child: IconButtonFooter(
              controller: _newsController,
              icons: Icons8.bookmark_in_book,
              namePage: 'Tin',
              color: nameRoute == '/newsPage' ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
