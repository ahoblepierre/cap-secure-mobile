import 'package:equatable/equatable.dart';

abstract class AlertEvent extends Equatable {
  const AlertEvent();

  @override
  List<Object> get props => [];
}

// Événement pour récupérer les alertes
class FetchAlerts extends AlertEvent {
  const FetchAlerts();
}

// Événement pour envoyer une alerte
class SendAlert extends AlertEvent {
  final int alertId;

  const SendAlert({required this.alertId});

  @override
  List<Object> get props => [alertId];
}
