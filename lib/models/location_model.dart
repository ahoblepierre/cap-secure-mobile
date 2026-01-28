import 'dart:math';

import 'package:equatable/equatable.dart';

class LocationModel extends Equatable {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? altitude;
  final double? speed;
  final DateTime timestamp;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.altitude,
    this.speed,
    required this.timestamp,
  });

  // Convertir en JSON pour l'API
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'altitude': altitude,
      'speed': speed,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Créer depuis JSON
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      accuracy: json['accuracy'] as double?,
      altitude: json['altitude'] as double?,
      speed: json['speed'] as double?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  // Calculer la distance entre deux points (formule de Haversine)
  static double calculateDistance(LocationModel loc1, LocationModel loc2) {
    const earthRadius = 6371; // Rayon de la Terre en km

    final lat1Rad = _degToRad(loc1.latitude);
    final lat2Rad = _degToRad(loc2.latitude);
    final deltaLat = _degToRad(loc2.latitude - loc1.latitude);
    final deltaLon = _degToRad(loc2.longitude - loc1.longitude);

    final a =
        (sin(deltaLat / 2) * sin(deltaLat / 2)) +
        (cos(lat1Rad) * cos(lat2Rad) * sin(deltaLon / 2) * sin(deltaLon / 2));

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c; // Distance en km
  }

  static double _degToRad(double deg) => deg * (3.141592653589793 / 180);

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    accuracy,
    altitude,
    speed,
    timestamp,
  ];
}
