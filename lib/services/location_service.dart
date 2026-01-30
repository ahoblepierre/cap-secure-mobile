import 'dart:developer';

import 'package:cap_secure_mobile/models/location_model.dart';
import 'package:geolocator/geolocator.dart';

/// Service professionnel pour gérer la géolocalisation de l'agent
///
/// Ce service encapsule toute la logique de localisation et offre:
/// - Récupération de la position actuelle
/// - Gestion des permissions
/// - Vérification si le service de localisation est activé
/// - Gestion des erreurs
/// - Caching optionnel de la dernière position
class LocationService {
  static final LocationService _instance = LocationService._internal();

  LocationModel? _cachedLocation;
  DateTime? _lastLocationTime;

  // Cache expiry en secondes
  static const int cacheExpirySeconds = 60;

  LocationService._internal();

  /// Singleton pattern pour une utilisation simple
  factory LocationService() {
    return _instance;
  }

  /// Récupérer la position actuelle de l'utilisateur
  ///
  /// Returns: LocationModel contenant latitude, longitude et autres informations
  /// Throws: LocationException si la position ne peut pas être obtenue
  Future<LocationModel> getCurrentLocation({bool forceRefresh = false}) async {
    try {
      // Vérifier le cache
      if (!forceRefresh &&
          _cachedLocation != null &&
          _lastLocationTime != null) {
        final elapsed = DateTime.now().difference(_lastLocationTime!).inSeconds;
        if (elapsed < cacheExpirySeconds) {
          log('🎯 Position depuis le cache (${elapsed}s)');
          return _cachedLocation!;
        }
      }

      // Vérifier si le service de localisation est activé
      final isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        log('❌ Service de localisation désactivé');
        throw LocationException('Le service de localisation est désactivé');
      }

      // Vérifier et demander les permissions
      final hasPermission = await _checkAndRequestPermission();
      if (!hasPermission) {
        log('❌ Permission de localisation refusée');
        throw LocationException('Permission de localisation refusée');
      }

      // Récupérer la position
      log('🔍 Récupération de la position...');
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0, // Pas de filtre de distance pour une seule requête
        ),
      );

      // Créer le LocationModel
      _cachedLocation = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        altitude: position.altitude,
        speed: position.speed,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          position.timestamp.millisecondsSinceEpoch,
        ),
      );

      _lastLocationTime = DateTime.now();

      log(
        '✅ Position obtenue: ${_cachedLocation!.latitude}, ${_cachedLocation!.longitude}',
      );

      return _cachedLocation!;
    } on LocationException {
      rethrow;
    } catch (e) {
      log('❌ Erreur: $e');
      throw LocationException(
        'Erreur lors de la récupération de la position: $e',
      );
    }
  }

  /// Récupérer le flux continu de positions (pour un suivi en temps réel)
  ///
  /// Returns: Stream de LocationModel
  Stream<LocationModel> getPositionStream({
    int distanceFilter =
        10, // Distance minimale entre les mises à jour (en mètres)
  }) {
    log('📍 Démarrage du suivi de position en temps réel');

    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
      ),
    ).map((position) {
      _cachedLocation = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        altitude: position.altitude,
        speed: position.speed,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          position.timestamp.millisecondsSinceEpoch,
        ),
      );

      _lastLocationTime = DateTime.now();

      log(
        '📍 Position mise à jour: ${position.latitude}, ${position.longitude}',
      );

      return _cachedLocation!;
    });
  }

  /// Vérifier et demander les permissions de localisation
  Future<bool> _checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        log('⚠️ Permission refusée');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      log('⚠️ Permission refusée de façon permanente');
      return false;
    }

    log('✅ Permission de localisation accordée');
    return true;
  }

  /// Vérifier si le service de localisation est activé
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Ouvrir les paramètres de localisation du système
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Obtenir la dernière position en cache
  LocationModel? getCachedLocation() {
    return _cachedLocation;
  }

  /// Effacer le cache de position
  void clearCache() {
    _cachedLocation = null;
    _lastLocationTime = null;
    log('🗑️ Cache de position effacé');
  }

  /// Vérifier si la position en cache est valide
  bool isCacheValid() {
    if (_cachedLocation == null || _lastLocationTime == null) {
      return false;
    }

    final elapsed = DateTime.now().difference(_lastLocationTime!).inSeconds;
    return elapsed < cacheExpirySeconds;
  }
}

/// Exception personnalisée pour les erreurs de localisation
class LocationException implements Exception {
  final String message;

  LocationException(this.message);

  @override
  String toString() => 'LocationException: $message';
}
