import 'package:intl/intl.dart';

class AgentNotification {
  final String id;
  final String title;
  final String description;
  final DateTime date;

  AgentNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  factory AgentNotification.fromJson(Map<String, dynamic> json) {
    return AgentNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  // Formater la date de manière lisible
  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final notificationDate = DateTime(date.year, date.month, date.day);

    if (notificationDate == today) {
      return 'Aujourd’hui ${DateFormat('HH:mm').format(date)}';
    } else if (notificationDate == yesterday) {
      return 'Hier ${DateFormat('HH:mm').format(date)}';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  // Vérifier si c'est une nouvelle notification (< 24h)
  bool get isNew {
    final now = DateTime.now();
    final difference = now.difference(date);
    return difference.inHours < 24;
  }

  // Mock data
  static List<AgentNotification> get mockNotifications {
    final now = DateTime.now();
    return [
      AgentNotification(
        id: '1',
        title: 'Nouveau shift assigné',
        description:
            'Vous avez été assigné au site Central pour le shift de nuit.',
        date: now.subtract(const Duration(hours: 2)),
      ),
      AgentNotification(
        id: '2',
        title: 'Rapport quotidien requis',
        description:
            'N\'oubliez pas de soumettre votre rapport de fin de shift.',
        date: now.subtract(const Duration(hours: 6)),
      ),
      AgentNotification(
        id: '3',
        title: 'Mise à jour sécurité',
        description:
            'Nouvelles procédures de sécurité en vigueur à partir d\'aujourd\'hui.',
        date: now.subtract(const Duration(hours: 12)),
      ),
      AgentNotification(
        id: '4',
        title: 'Maintenance système',
        description: 'Le système sera indisponible ce soir de 22h à 23h.',
        date: now.subtract(const Duration(hours: 18)),
      ),
      AgentNotification(
        id: '5',
        title: 'Formation obligatoire',
        description:
            'Session de formation sur les nouveaux équipements demain 9h.',
        date: now.subtract(const Duration(days: 1, hours: 2)),
      ),
      AgentNotification(
        id: '6',
        title: 'Changement d\'horaire',
        description:
            'Votre shift de demain a été modifié : 14h-22h au lieu de 8h-16h.',
        date: now.subtract(const Duration(days: 1, hours: 6)),
      ),
      AgentNotification(
        id: '7',
        title: 'Équipement défectueux',
        description: 'Signalez tout équipement défectueux via l\'app.',
        date: now.subtract(const Duration(days: 2)),
      ),
      AgentNotification(
        id: '8',
        title: 'Réunion équipe',
        description: 'Réunion d\'équipe programmée pour vendredi 10h.',
        date: now.subtract(const Duration(days: 3)),
      ),
      AgentNotification(
        id: '9',
        title: 'Mise à jour application',
        description: 'Nouvelle version disponible avec améliorations sécurité.',
        date: now.subtract(const Duration(days: 4)),
      ),
      AgentNotification(
        id: '10',
        title: 'Contrôle qualité',
        description: 'Audit de qualité prévu la semaine prochaine.',
        date: now.subtract(const Duration(days: 5)),
      ),
      AgentNotification(
        id: '11',
        title: 'Vacances approuvées',
        description: 'Vos congés du 15 au 20 ont été approuvés.',
        date: now.subtract(const Duration(days: 7)),
      ),
      AgentNotification(
        id: '12',
        title: 'Changement de site',
        description: 'Réaffectation temporaire au site Nord pour 2 semaines.',
        date: now.subtract(const Duration(days: 10)),
      ),
      AgentNotification(
        id: '13',
        title: 'Formation sécurité',
        description:
            'Rappel : formation sécurité obligatoire le mois prochain.',
        date: now.subtract(const Duration(days: 14)),
      ),
      AgentNotification(
        id: '14',
        title: 'Évaluation performance',
        description: 'Votre évaluation trimestrielle est disponible.',
        date: now.subtract(const Duration(days: 20)),
      ),
      AgentNotification(
        id: '15',
        title: 'Mise à jour politique',
        description: 'Nouvelle politique de confidentialité en vigueur.',
        date: now.subtract(const Duration(days: 25)),
      ),
      AgentNotification(
        id: '16',
        title: 'Maintenance préventive',
        description: 'Maintenance des caméras ce weekend.',
        date: now.subtract(const Duration(days: 30)),
      ),
    ]..sort((a, b) => b.date.compareTo(a.date)); // Tri décroissant
  }
}
