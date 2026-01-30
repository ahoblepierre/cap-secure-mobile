import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cap_secure_mobile/models/agent_notification.dart';
import 'package:cap_secure_mobile/repository/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;

  NotificationBloc({required NotificationRepository notificationRepository})
    : _notificationRepository = notificationRepository,
      super(const NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<RefreshNotifications>(_onLoadNotifications);
  }

  Future<void> _onLoadNotifications(
    NotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoading());

    try {
      final List<AgentNotification> notifications =
          await _notificationRepository.getAllNotifications();
      if (notifications.isEmpty) {
        emit(const NotificationEmpty());
      } else {
        emit(NotificationLoaded(notifications));
      }
    } catch (e) {
      emit(
        NotificationError(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
