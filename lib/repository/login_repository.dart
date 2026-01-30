import 'dart:developer';

import 'package:cap_secure_mobile/config/app_config.dart';
import 'package:cap_secure_mobile/models/login_response_model.dart';
import 'package:cap_secure_mobile/services/notification_service.dart';
import 'package:dio/dio.dart';

class LoginRepository {
  final Dio _dio = Dio();

  Future<LoginResponseModel> login({
    required String registrationNumber,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        getUrl('login').toString(),
        data: {'registration_number': registrationNumber, 'password': password},
        options: Options(
          headers: headers,
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponseModel.fromJson(response.data);

        // Sauvegarder le token
        if (loginResponse.status && loginResponse.token.isNotEmpty) {
          await box.write('token', loginResponse.token);
          await box.write('agent', loginResponse.agent.toJson());
        }

        return loginResponse;
      } else {
        throw Exception('Erreur de connexion');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Erreur lors de la connexion',
      );
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  Future<LoginResponseModel> changePassword({
    required String registrationNumber,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        getUrl('change-password').toString(),
        data: {
          'registration_number': registrationNumber,
          'password': password,
          'fcm_token': await NotificationService.instance.getToken(),
        },
        options: Options(
          headers: headersWithToken,
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponseModel.fromJson(response.data);

        // Sauvegarder le token et l'agent
        if (loginResponse.status && loginResponse.token.isNotEmpty) {
          await box.write('token', loginResponse.token);
          await box.write('agent', loginResponse.agent.toJson());
        }

        return loginResponse;
      } else {
        throw Exception('Erreur lors du changement de mot de passe');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            'Erreur lors du changement de mot de passe',
      );
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  Future<void> listenToken({required String token}) async {
    try {
      final response = await _dio.post(
        getUrl('listen-token').toString(),
        data: {'fcm_token': token},
        options: Options(
          headers: headersWithToken,
          contentType: Headers.jsonContentType,
        ),
      );
      if (response.statusCode == 200) {
        return;
      } else {
        log('Erreur lors de l\'écoute du token FCM');
      }
    } on DioException catch (e) {
      log(
        e.response?.data['message'] ?? 'Erreur lors de l\'écoute du token FCM',
      );
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
}
