import 'dart:developer';

import 'package:cap_secure_mobile/repository/login_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  late GoRouter _router;

  Future<void> init(GoRouter router) async {
    _router = router;

    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: androidInit);

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        // final payload = response.payload;
        // if (payload != null && payload.isNotEmpty) {
        //   _router.pushNamed("home", extra: 2);
        // }
        _router.pushNamed("home", extra: 2);
      },
    );

    // Permission Android 13+
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    _listenFirebase();
  }

  // ================= FIREBASE =================

  /// Récupérer le token actuel
  Future<String?> getToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    log('FCM TOKEN: $token');
    return token;
  }

  /// Écoute changement de token (important)
  void listenTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      // Listen to token refresh , add to server
      await LoginRepository().listenToken(token: newToken);
      log('FCM TOKEN UPDATED: $newToken');
    });
  }

  void _listenFirebase() {
    /// FOREGROUND
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showFromFirebase(message);
    });

    /// CLICK quand app était en background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final route = message.data['route'];
      if (route != null) {
        _router.pushNamed("home", extra: 2);
      }
    });
  }

  // ================= LOCAL NOTIFICATION =================

  AndroidNotificationDetails _androidDetails() {
    return const AndroidNotificationDetails(
      'default',
      'Default',
      channelDescription: 'Default channel',
      importance: Importance.max,
      priority: Priority.high,
    );
  }

  NotificationDetails get _details =>
      NotificationDetails(android: _androidDetails());

  int generateId() => DateTime.now().millisecondsSinceEpoch.remainder(100000);

  /// Affichage depuis Firebase
  Future<void> showFromFirebase(RemoteMessage message) async {
    final id = generateId();

    final title = message.notification?.title ?? 'Notification';
    final body = message.notification?.body ?? '';

    // Route envoyée depuis backend Firebase
    final route = message.data['route'];

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: _details,
      payload: route,
    );
  }

  Future<void> show({
    required String title,
    required String body,
    String? payload,
  }) async {
    final id = generateId();

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: _details,
      payload: payload,
    );
  }
}
