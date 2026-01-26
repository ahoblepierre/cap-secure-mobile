import 'package:cap_secure_mobile/config/app_style.dart';
import 'package:cap_secure_mobile/models/agent.dart';
import 'package:cap_secure_mobile/models/alert_model.dart';
import 'package:cap_secure_mobile/widgets/primary_button.dart';
import 'package:flutter/material.dart';

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
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
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
              content: Column(
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
                    items: mockAlerts.map((alert) {
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
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Annuler',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                if (_selectedAlert != null)
                  ElevatedButton(
                    onPressed: () {
                      // Logique pour envoyer l'alerte
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Alerte "${_selectedAlert!.type}" envoyée !',
                          ),
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kBleue,
                      foregroundColor: Colors.white,
                      shape: ContinuousRectangleBorder(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Envoyer'),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final agent = Agent.mockAgent;

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
                  child: agent.imageUrl != null
                      ? ClipOval(
                          child: Image.network(
                            agent.imageUrl!,
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

                // Nom
                Text(
                  agent.fullName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Matricule
                Chip(
                  label: Text(
                    agent.matricule,
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
                  value: agent.phone,
                ),
                const SizedBox(height: 16),

                _buildInfoCard(
                  icon: Icons.email,
                  title: 'Email',
                  value: agent.email,
                ),

                Padding(padding: const EdgeInsets.only(top: 32.0)),

                PrimaryButton(
                  labelText: 'Lancer une alerte',
                  backgroundColor: Colors.redAccent,
                  onPress: () {
                    _showAlertDialog("Envoyé une alerte d'urgence");
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
