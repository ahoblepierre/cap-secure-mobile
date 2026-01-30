import 'dart:developer';

import 'package:cap_secure_mobile/config/app_config.dart';
import 'package:cap_secure_mobile/models/alert_model.dart';
import 'package:dio/dio.dart';

class AlertRepository {
  final Dio _dio = Dio(BaseOptions(validateStatus: (status) => status != null));

  /// Extraire le message d'erreur depuis la réponse du serveur
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
          } else if (errors is List) {
            return errors.join(', ');
          }
        }
      }
    } catch (e) {
      log('Erreur lors de l\'extraction du message: $e');
    }
    return 'Une erreur est survenue';
  }

  // Récupérer tous les alertes depuis l'API
  Future<List<AlertModel>> getAllAlerts() async {
    try {
      final response = await _dio.get(
        getUrl("alerts").toString(),
        options: Options(headers: headersWithToken),
      );

      if (response.statusCode == 200) {
        log('✅ Alertes récupérées');
        final data = response.data;
        List<AlertModel> alerts = [];
        if (data is List) {
          alerts = (data)
              .map(
                (alert) => AlertModel.fromJson(alert as Map<String, dynamic>),
              )
              .toList();
        } else if (data is Map && data.containsKey('alerts')) {
          alerts = (data['alerts'] as List)
              .map(
                (alert) => AlertModel.fromJson(alert as Map<String, dynamic>),
              )
              .toList();
        }
        return alerts;
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
          'Erreur lors de la récupération des alertes: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // Envoyer une alerte
  Future<void> sendAlert(int alertId) async {
    try {
      final response = await _dio.post(
        getUrl('alerts/send').toString(),
        options: Options(headers: headersWithToken),
        data: {'alert_id': alertId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('✅ Alerte envoyée');
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
          'Erreur lors de l\'envoi de l\'alerte: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('❌ Erreur: $e');
      rethrow;
    }
  }
}
