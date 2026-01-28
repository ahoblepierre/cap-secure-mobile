import 'package:cap_secure_mobile/presentation/alert/bloc/alert_event.dart';
import 'package:cap_secure_mobile/presentation/alert/bloc/alert_state.dart';
import 'package:cap_secure_mobile/repository/alert_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final AlertRepository alertRepository;

  AlertBloc({required this.alertRepository}) : super(const AlertInitial()) {
    // Écouter l'événement FetchAlerts
    on<FetchAlerts>(_onFetchAlerts);

    // Écouter l'événement SendAlert
    on<SendAlert>(_onSendAlert);
  }

  Future<void> _onFetchAlerts(
    FetchAlerts event,
    Emitter<AlertState> emit,
  ) async {
    emit(const AlertLoading());

    try {
      final alerts = await alertRepository.getAllAlerts();

      if (alerts.isEmpty) {
        emit(const AlertEmpty());
      } else {
        emit(AlertLoaded(alerts: alerts));
      }
    } catch (e) {
      emit(AlertError(message: e.toString()));
    }
  }

  Future<void> _onSendAlert(SendAlert event, Emitter<AlertState> emit) async {
    // Garder l'état actuel des alertes
    final previousState = state;

    emit(const AlertSending());

    try {
      await alertRepository.sendAlert(event.alertId);

      // Retrouner à l'état AlertLoaded si c'était le cas avant
      if (previousState is AlertLoaded) {
        emit(AlertSent(message: 'Alerte envoyée avec succès!'));
        // Rester quelques secondes en AlertSent puis revenir à AlertLoaded
        await Future.delayed(const Duration(milliseconds: 500));
        emit(AlertLoaded(alerts: previousState.alerts));
      } else {
        emit(AlertSent(message: 'Alerte envoyée avec succès!'));
      }
    } catch (e) {
      emit(AlertSendError(message: e.toString()));
      // Revenir à l'état précédent après l'erreur
      if (previousState is AlertLoaded) {
        await Future.delayed(const Duration(milliseconds: 500));
        emit(AlertLoaded(alerts: previousState.alerts));
      }
    }
  }
}
