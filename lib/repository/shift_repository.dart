import 'dart:developer';

import 'package:cap_secure_mobile/config/app_config.dart';
import 'package:cap_secure_mobile/models/shift.dart';
import 'package:dio/dio.dart';

class ShiftRepository {
  final Dio _dio = Dio();

  Future<List<Shift>> getAllShifts() async {
    try {
      final response = await _dio.get(
        getUrl('shifts').toString(),
        options: Options(
          headers: headersWithToken,
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        log('Response Status code : ${response.statusCode}');

        final shifts = data.map((shift) => Shift.fromJson(shift)).toList();

        return shifts;
      } else {
        throw Exception('Erreur lors du chargement des shifts');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Erreur lors du chargement des shifts',
      );
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
}
