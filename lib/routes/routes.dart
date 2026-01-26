import 'package:cap_secure_mobile/presentation/home/home_page.dart';
import 'package:cap_secure_mobile/presentation/login/login_page.dart';
import 'package:cap_secure_mobile/presentation/splach_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const home = "/";
  static const login = "/login";
  static const splash = "/splash";

  static GoRouter router = GoRouter(
    redirect: (context, state) {
      final isLoggin = true;
      if (isLoggin) {
        return login;
      }
      // return home;
    },
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
    ],
  );
}
