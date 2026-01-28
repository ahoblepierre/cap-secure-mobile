import 'package:cap_secure_mobile/models/alert_model.dart';
import 'package:equatable/equatable.dart';

abstract class AlertState extends Equatable {
  const AlertState();

  @override
  List<Object?> get props => [];
}

// État initial
class AlertInitial extends AlertState {
  const AlertInitial();
}

// État de chargement
class AlertLoading extends AlertState {
  const AlertLoading();
}

// État avec alertes chargées
class AlertLoaded extends AlertState {
  final List<AlertModel> alerts;

  const AlertLoaded({required this.alerts});

  @override
  List<Object> get props => [alerts];
}

// État sans alertes
class AlertEmpty extends AlertState {
  const AlertEmpty();
}

// État d'erreur
class AlertError extends AlertState {
  final String message;

  const AlertError({required this.message});

  @override
  List<Object> get props => [message];
}

// État d'envoi d'alerte en cours
class AlertSending extends AlertState {
  const AlertSending();
}

// État d'alerte envoyée avec succès
class AlertSent extends AlertState {
  final String message;

  const AlertSent({required this.message});

  @override
  List<Object> get props => [message];
}

// État d'erreur d'envoi
class AlertSendError extends AlertState {
  final String message;

  const AlertSendError({required this.message});

  @override
  List<Object> get props => [message];
}
