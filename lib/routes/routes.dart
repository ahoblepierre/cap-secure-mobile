import 'package:cap_secure_mobile/presentation/home/home_page.dart';
import 'package:cap_secure_mobile/presentation/login/login_page.dart';
import 'package:cap_secure_mobile/presentation/splach_screen/splash_screen.dart';
import 'package:cap_secure_mobile/presentation/timetable/timetable_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const home = "/home";
  static const login = "/login";
  static const splash = "/splash";
  static const timetable = "/timetable";
  static const profile = "/profile";

  static GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: home,
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: login,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: splash,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: timetable,
        builder: (BuildContext context, GoRouterState state) {
          return const TimetablePage();
        },
      ),
    ],
  );
}
