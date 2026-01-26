import 'package:cap_secure_mobile/config/app_style.dart';
import 'package:cap_secure_mobile/presentation/scanner/bloc/scanner_bloc.dart';
import 'package:cap_secure_mobile/presentation/splach_screen/bloc/splash_bloc.dart';
import 'package:cap_secure_mobile/presentation/timetable/bloc/shift_bloc.dart';
import 'package:cap_secure_mobile/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(create: (context) => SplashBloc()),
        BlocProvider<ShiftBloc>(create: (context) => ShiftBloc()),
        BlocProvider<ScannerBloc>(create: (context) => ScannerBloc()),
      ],
      child: MaterialApp.router(
        routerConfig: Routes.router,
        debugShowCheckedModeBanner: false,
        title: 'CAP SECURE',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: kBleue),
          textTheme: textTheme,
        ),
      ),
    );
  }
}
