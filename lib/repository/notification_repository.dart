import 'dart:developer';

import 'package:cap_secure_mobile/config/app_config.dart';
import 'package:cap_secure_mobile/models/agent_notification.dart';
import 'package:dio/dio.dart';

class NotificationRepository {
  final Dio _dio = Dio(BaseOptions(validateStatus: (status) => status != null));

  String _extractErrorMessage(dynamic responseData) {
    try {
      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('message')) {
          return responseData['message'] as String;
        }
        if (responseData.containsKey('error')) {
          return responseData['error'] as String;
        }
        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'];
          if (errors is Map) {
            return errors.values.join(', ');
          }
          if (errors is List) {
            return errors.join(', ');
          }
        }
      }
    } catch (e) {
      log('Erreur lors de l\'extraction du message: $e');
    }
    return 'Une erreur est survenue';
  }

  Future<List<AgentNotification>> getAllNotifications() async {
    try {
      final response = await _dio.get(
        getUrl('notifications').toString(),
        options: Options(headers: headersWithToken),
      );

      if (response.statusCode == 200) {
        log('✅ Notifications récupérées');
        final data = response.data;
        List<AgentNotification> notifications = [];
        if (data is List) {
          notifications = data
              .map((n) => AgentNotification.fromJson(n as Map<String, dynamic>))
              .toList();
        } else if (data is Map && data.containsKey('notifications')) {
          notifications = (data['notifications'] as List)
              .map((n) => AgentNotification.fromJson(n as Map<String, dynamic>))
              .toList();
        }
        return notifications;
      } else if (response.statusCode == 429) {
        final errorMessage = _extractErrorMessage(response.data);
        log('⚠️ Trop de requêtes (429)');
        throw Exception('Trop de requêtes. $errorMessage');
      } else if (response.statusCode == 400) {
        final errorMessage = _extractErrorMessage(response.data);
        log('❌ Mauvaise requête (400)');
        throw Exception('Données invalides: $errorMessage');
      } else if (response.statusCode == 500) {
        final errorMessage = _extractErrorMessage(response.data);
        log('❌ Erreur serveur (500)');
        throw Exception('Erreur serveur: $errorMessage');
      } else {
        log('❌ Erreur (${response.statusCode})');
        throw Exception(
          'Erreur lors de la récupération des notifications: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
