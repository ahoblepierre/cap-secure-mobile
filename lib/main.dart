import 'package:cap_secure_mobile/config/app_style.dart';
import 'package:cap_secure_mobile/firebase_options.dart';
import 'package:cap_secure_mobile/presentation/login/bloc/login_bloc.dart';
import 'package:cap_secure_mobile/presentation/notification/bloc/notification_bloc.dart';
import 'package:cap_secure_mobile/presentation/scanner/bloc/scanner_bloc.dart';
import 'package:cap_secure_mobile/presentation/splach_screen/bloc/splash_bloc.dart';
import 'package:cap_secure_mobile/presentation/timetable/bloc/shift_bloc.dart';
import 'package:cap_secure_mobile/repository/notification_repository.dart';
import 'package:cap_secure_mobile/repository/shift_repository.dart';
import 'package:cap_secure_mobile/routes/routes.dart';
import 'package:cap_secure_mobile/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// BACKGROUND HANDLER (top level obligatoire)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Affiche une notif locale même en background
  await NotificationService.instance.showFromFirebase(message);
}

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Firebase
  await Firebase.initializeApp();

  // Enregistrement du background handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialisation du service de notification avec le router
  await NotificationService.instance.init(Routes.router);

  //To listen for token refresh
  NotificationService.instance.listenTokenRefresh();

  // Initialisation de GetStorage
  await GetStorage.init();

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
        BlocProvider<ScannerBloc>(create: (context) => ScannerBloc()),
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
        BlocProvider<ShiftBloc>(
          create: (context) => ShiftBloc(shiftRepository: ShiftRepository()),
        ),
        BlocProvider(
          create: (context) => NotificationBloc(
            notificationRepository: NotificationRepository(),
          ),
        ),
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
