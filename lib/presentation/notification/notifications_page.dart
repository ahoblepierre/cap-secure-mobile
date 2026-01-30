import 'package:cap_secure_mobile/models/agent_notification.dart';
import 'package:cap_secure_mobile/presentation/notification/bloc/notification_bloc.dart';
import 'package:cap_secure_mobile/presentation/notification/bloc/notification_event.dart';
import 'package:cap_secure_mobile/presentation/notification/bloc/notification_state.dart';
import 'package:cap_secure_mobile/repository/notification_repository.dart';
import 'package:cap_secure_mobile/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late NotificationBloc _notificationBloc;
  bool _isLoadingDialogShown = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _notificationBloc = NotificationBloc(
      notificationRepository: NotificationRepository(),
    );

    // Charger les notifications au démarrage
    _notificationBloc.add(LoadNotifications());

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _notificationBloc.close();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    // Déclencher un rafraîchissement via le bloc
    _notificationBloc.add(RefreshNotifications());

    // On attend un court instant pour permettre l'affichage du loader
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _notificationBloc,
      child: Container(
        color: Colors.grey[100],
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: BlocListener<NotificationBloc, NotificationState>(
            listener: (context, state) {
              if (state is NotificationLoading) {
                if (!_isLoadingDialogShown) {
                  LoadingDialog.show(
                    context,
                    message: 'Chargement des notifications...',
                  );
                  _isLoadingDialogShown = true;
                }
              } else {
                if (_isLoadingDialogShown) {
                  LoadingDialog.hide(context);
                  _isLoadingDialogShown = false;
                }
              }

              if (state is NotificationError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur: ${state.message}'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            },
            child: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                if (state is NotificationInitial ||
                    state is NotificationLoading) {
                  return const SizedBox.expand();
                } else if (state is NotificationLoaded) {
                  final notifications = state.notifications;

                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: Theme.of(context).primaryColor,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return _buildNotificationCard(notification);
                      },
                    ),
                  );
                } else if (state is NotificationEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.notifications_off_outlined,
                            size: 64,
                            color: Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Aucune notification',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Vous n\'avez reçu aucune notification récemment.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () =>
                              _notificationBloc.add(LoadNotifications()),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Rafraîchir'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is NotificationError) {
                  return Center(child: Text('Erreur: ${state.message}'));
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(AgentNotification notification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icône
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(
                Icons.notifications,
                color: Theme.of(context).primaryColor,
                size: 20.0,
              ),
            ),
            const SizedBox(width: 16.0),

            // Contenu
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre et badge Nouveau
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                        ),
                      ),
                      if (notification.isNew)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Text(
                            'Nouveau',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8.0),

                  // Description
                  Text(
                    notification.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12.0),

                  // Date
                  Text(
                    notification.formattedDate,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
