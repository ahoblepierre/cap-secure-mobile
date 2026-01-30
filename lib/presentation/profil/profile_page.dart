import 'dart:developer';

import 'package:cap_secure_mobile/config/app_config.dart';
import 'package:cap_secure_mobile/config/app_style.dart';
import 'package:cap_secure_mobile/models/login_response_model.dart';
import 'package:cap_secure_mobile/models/alert_model.dart';
import 'package:cap_secure_mobile/presentation/alert/bloc/alert_bloc.dart';
import 'package:cap_secure_mobile/presentation/alert/bloc/alert_event.dart';
import 'package:cap_secure_mobile/presentation/alert/bloc/alert_state.dart';
import 'package:cap_secure_mobile/repository/alert_repository.dart';
import 'package:cap_secure_mobile/widgets/custom_dialog.dart';
import 'package:cap_secure_mobile/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  AlertModel? _selectedAlert;
  late AgentModel _agent;
  bool _isLoading = true;
  String? _errorMessage;
  late AlertBloc _alertBloc;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Initialiser le AlertBloc
    _alertBloc = AlertBloc(alertRepository: AlertRepository());
    // Charger les alertes
    _alertBloc.add(const FetchAlerts());

    // Charger les données de l'agent depuis GetStorage
    _loadAgentData();
  }

  Future<void> _loadAgentData() async {
    try {
      final agentData = box.read('agent');

      log('Agent data from storage: $agentData');

      if (agentData != null) {
        // Si c'est un Map (depuis JSON), créer un AgentModel
        if (agentData is Map<String, dynamic>) {
          _agent = AgentModel.fromJson(agentData);
        } else if (agentData is AgentModel) {
          _agent = agentData;
        }

        setState(() {
          _isLoading = false;
        });
        _animationController.forward();
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Aucune donnée utilisateur trouvée';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erreur: ${e.toString()}';
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _alertBloc.close();
    super.dispose();
  }

  // ignore: unused_element
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmer la déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Logique de déconnexion ici
              },
              child: const Text('Déconnexion'),
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog(String title) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: _alertBloc,
          child: BlocListener<AlertBloc, AlertState>(
            listenWhen: (previous, current) =>
                current is AlertSent || current is AlertSendError,
            listener: (context, state) {
              if (state is AlertSent) {
                Navigator.of(context).pop(); // Fermer le dialog
                CustomDialog.showSuccessDialog(
                  context,
                  title: 'Succès',
                  message: state.message,
                  buttonText: 'OK',
                );
              } else if (state is AlertSendError) {
                CustomDialog.showErrorDialog(
                  context,
                  title: 'Erreur',
                  message: state.message,
                  buttonText: 'Réessayer',
                );
              }
            },
            child: StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  insetPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: BlocBuilder<AlertBloc, AlertState>(
                    builder: (context, state) {
                      if (state is AlertLoading) {
                        return SizedBox(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 16),
                                const Text('Chargement des alertes...'),
                              ],
                            ),
                          ),
                        );
                      }

                      if (state is AlertEmpty) {
                        return SizedBox(
                          height: 150,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 48,
                                  color: Colors.orange[600],
                                ),
                                const SizedBox(height: 12),
                                const Text('Aucune alerte disponible'),
                              ],
                            ),
                          ),
                        );
                      }

                      if (state is AlertError) {
                        return SizedBox(
                          height: 150,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Récupérer les alertes du state AlertLoaded
                      List<AlertModel> alerts = [];
                      if (state is AlertLoaded) {
                        alerts = state.alerts;
                      }

                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Choisir votre alerte",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: kGrey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<AlertModel>(
                              decoration: InputDecoration(
                                labelText: 'Type d\'alerte',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: kGrey),
                                ),
                              ),
                              initialValue: _selectedAlert,
                              items: alerts.map((alert) {
                                return DropdownMenuItem<AlertModel>(
                                  value: alert,
                                  child: Text(alert.type),
                                );
                              }).toList(),
                              onChanged: (AlertModel? newValue) {
                                setState(() {
                                  _selectedAlert = newValue;
                                });
                              },
                            ),
                            if (_selectedAlert != null) ...[
                              const SizedBox(height: 16),
                              Text(
                                'Message: ${_selectedAlert!.message}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Annuler',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (_selectedAlert != null)
                      BlocBuilder<AlertBloc, AlertState>(
                        builder: (context, state) {
                          final isSending = state is AlertSending;

                          return ElevatedButton(
                            onPressed: isSending
                                ? null
                                : () {
                                    // Envoyer l'alerte via le BLoC
                                    _alertBloc.add(
                                      SendAlert(alertId: _selectedAlert!.id),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kBleue,
                              foregroundColor: Colors.white,
                              shape: const ContinuousRectangleBorder(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: isSending
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text('Envoyer'),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Afficher un loader si les données se chargent
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Chargement des données...'),
          ],
        ),
      );
    }

    // Afficher une erreur si nécessaire
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!),
          ],
        ),
      );
    }

    return SizedBox(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          color: Colors.grey[100],
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: _agent.imageUrl != null && _agent.imageUrl!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            _agent.imageUrl!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildDefaultAvatar(),
                          ),
                        )
                      : _buildDefaultAvatar(),
                ),
                const SizedBox(height: 16),

                // Nom et Prénom
                Text(
                  '${_agent.firstName} ${_agent.name}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Numéro d'enregistrement
                Chip(
                  label: Text(
                    _agent.registrationNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                ),
                const SizedBox(height: 32),

                // Cards d'informations
                _buildInfoCard(
                  icon: Icons.phone,
                  title: 'Téléphone',
                  value: _agent.phone,
                ),
                const SizedBox(height: 16),

                _buildInfoCard(
                  icon: Icons.email,
                  title: 'Email',
                  value: _agent.email,
                ),
                const SizedBox(height: 16),

                _buildInfoCard(
                  icon: Icons.badge,
                  title: 'ID Agent',
                  value: _agent.id.toString(),
                ),

                Padding(padding: const EdgeInsets.only(top: 32.0)),

                PrimaryButton(
                  labelText: 'Lancer une alerte',
                  backgroundColor: Colors.redAccent,
                  onPress: () {
                    _showAlertDialog("Envoyer une alerte d'urgence");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.security,
        size: 60,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black87,
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
