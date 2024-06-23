import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/auth/views/login_page.dart';
import '../features/auth/views/register_page.dart';
import '../features/pages/contactPage/contact_page.dart';
import '../features/pages/homePage/home_page.dart';
import '../features/pages/newsPage/news_page.dart';
import 'custom_transtion_page.dart';

/// The route configuration.
final GoRouter routeConfig = GoRouter(
  initialLocation: '/homePage',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildPageWithNoDefaultTransition(
          context: context,
          state: state,
          child: const LoginPage(),
        );
      },
      redirect: (context, state) async {
        // print('here');
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        // print(prefs.getBool('islogin'));
        if (prefs.getBool('islogin') == true) {
          return '/homePage';
        } else {
          return '/login';
        }
      },
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildPageWithNoDefaultTransition(
          context: context,
          state: state,
          child: const RegisterPage(),
        );
      },
    ),
    GoRoute(
      path: '/homePage',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const HomePage(),
        );
      },
    ),
    GoRoute(
      path: '/contactPage',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const ContactPage(),
        );
      },
    ),
    GoRoute(
      path: '/newsPage',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const NewsPage(),
        );
      },
    ),
  ],
);
