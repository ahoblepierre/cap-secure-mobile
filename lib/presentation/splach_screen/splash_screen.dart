import 'dart:developer';

import 'package:cap_secure_mobile/config/app_style.dart';
import 'package:cap_secure_mobile/presentation/splach_screen/bloc/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(SplashStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is SplashNavigateToLogin) {
          log('Splash State: $state');
          context.go('/login');
        }
      },
      child: const Scaffold(
        backgroundColor: kBleue,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}
