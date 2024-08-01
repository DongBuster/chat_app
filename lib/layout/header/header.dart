import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'viewModels/header_view_models.dart';
import 'views/header_contact_page.dart';
import 'views/header_home_page.dart';
import 'views/header_news_page.dart';
import 'widgets/button_icon.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isScrolling =
        Provider.of<HeaderViewModel>(context, listen: true).isScrolling;
    String nameRoute = GoRouterState.of(context).uri.toString();

    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isScrolling ? Colors.grey.shade100 : Colors.transparent,
          ),
        ),
        boxShadow: [
          isScrolling
              ? BoxShadow(
                  color: Colors.grey.shade300,
                  spreadRadius: 1,
                  blurRadius: 1,
                )
              : const BoxShadow(),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ButtonIcon(
            func: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icons.menu,
          ),
          const SizedBox(width: 30),
          nameRoute == '/homePage' ? const HeaderHomePage() : const SizedBox(),
          nameRoute == '/contactPage'
              ? const HeaderContactPage()
              : const SizedBox(),
          nameRoute == '/newsPage' ? const HeaderNewsPage() : const SizedBox(),
        ],
      ),
    );
  }
}
