import 'dart:developer';

import 'package:cap_secure_mobile/config/app_config.dart';
import 'package:cap_secure_mobile/models/location_model.dart';
import 'package:dio/dio.dart';

class ScannerRepository {
  final Dio _dio = Dio(
    BaseOptions(
      // Traiter tous les codes de statut comme des réponses (pas d'erreur automatique)
      validateStatus: (status) => status != null,
    ),
  );

  /// Extraire le message d'erreur depuis la réponse du serveur
  String _extractErrorMessage(dynamic responseData) {
    try {
      if (responseData is Map<String, dynamic>) {
        // Chercher les clés communes pour les messages d'erreur
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

  /// Soumettre un pointage avec localisation
  ///
  /// Envoie le code QR scanné avec la localisation de l'agent au serveur
  ///
  /// Parameters:
  ///   - scannedCode: Code QR scanné (business_location)
  ///   - location: Localisation actuelle de l'agent
  ///
  /// Body expected by API:
  /// {
  ///   "business_location": "code_qr",
  ///   "agent_location": {
  ///     "long": "18238982.84321934",
  ///     "lat": "-123.123123"
  ///   },
  ///   "score_time": "2026-01-28T16:45:30.000Z"
  /// }
  Future<Map<String, dynamic>> submitAttendance({
    required String scannedCode,
    required LocationModel location,
  }) async {
    try {
      final scoreTime = DateTime.now().toIso8601String();

      final requestBody = {
        'business_location': scannedCode,
        'agent_location': {
          'longitude': location.longitude.toString(),
          'latitude': location.latitude.toString(),
        },
        'score_time': scoreTime,
      };

      log('📤 Envoi du pointage: $requestBody');

      final response = await _dio.post(
        getUrl('add-scoring').toString(),
        options: Options(headers: headersWithToken),
        data: requestBody,
      );

      // Gérer les différents codes de statut HTTP
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('✅ Pointage accepté (${response.statusCode})');
        return {
          'success': true,
          'message': 'Pointage enregistré avec succès',
          'data': response.data,
        };
      }
      // Gérer le code 429 (Trop de requêtes)
      else if (response.statusCode == 429) {
        final errorMessage = _extractErrorMessage(response.data);
        log('⚠️ Trop de requêtes (429): $errorMessage');
        throw Exception('Trop de pointages. $errorMessage');
      }
      // Gérer le code 400 (Mauvaise requête)
      else if (response.statusCode == 400) {
        final errorMessage = _extractErrorMessage(response.data);
        log('❌ Mauvaise requête (400): $errorMessage');
        throw Exception('Données invalides: $errorMessage');
      }
      // Gérer le code 500 (Erreur serveur interne)
      else if (response.statusCode == 500) {
        final errorMessage = _extractErrorMessage(response.data);
        log('❌ Erreur serveur (500): $errorMessage');
        throw Exception('Erreur serveur. Veuillez réessayer plus tard.');
      }
      // Gérer les autres codes d'erreur
      else {
        final errorMessage = _extractErrorMessage(response.data);
        log('❌ Erreur (${response.statusCode}): $errorMessage');
        throw Exception(
          'Erreur serveur (${response.statusCode}): $errorMessage',
        );
      }
    } on DioException catch (e) {
      log('❌ Erreur Dio: ${e.message}');
      throw Exception(
        'Erreur réseau: ${e.message ?? "Impossible de se connecter au serveur"}',
      );
    } catch (e) {
      log('❌ Erreur: $e');
      rethrow;
    }
  }
}
