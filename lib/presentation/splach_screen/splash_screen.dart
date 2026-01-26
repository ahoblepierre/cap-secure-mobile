import 'package:cap_secure_mobile/config/app_style.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kBleue,
      body: Center(
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1.5),
      ),
    );
  }
}
