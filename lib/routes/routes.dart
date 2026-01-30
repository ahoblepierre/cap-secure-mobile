import 'package:cap_secure_mobile/presentation/change_password/change_password.dart';
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
  static const changePassword = "/change_password";

  static GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        name: 'home',
        path: home,
        builder: (BuildContext context, GoRouterState state) {
          final int index = state.extra as int? ?? 0;
          return HomePage(index: index);
        },
      ),
      GoRoute(
        name: 'login',
        path: login,
        builder: (BuildContext context, GoRouterState state) {
          return LoginPage();
        },
      ),
      GoRoute(
        name: 'splash',
        path: splash,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        name: 'timetable',
        path: timetable,
        builder: (BuildContext context, GoRouterState state) {
          return const TimetablePage();
        },
      ),
      GoRoute(
        name: 'changePassword',
        path: changePassword,
        builder: (BuildContext context, GoRouterState state) {
          final String registerationNumber = state.extra as String? ?? '';
          return ChangePassword(registerationNumber: registerationNumber);
        },
      ),
    ],
  );
}
