class AlertModel {
  final int id;
  final String type;
  final String message;

  AlertModel({required this.id, required this.type, required this.message});
}

final List<AlertModel> mockAlerts = [
  AlertModel(
    id: 1,
    type: "Alerte Médicale",
    message: "Besoin d'assistance médicale immédiate.",
  ),
  AlertModel(
    id: 2,
    type: "Alerte Incendie",
    message: "Incendie détecté dans le bâtiment.",
  ),
  AlertModel(
    id: 3,
    type: "Alerte Sécurité",
    message: "Intrusion suspecte signalée.",
  ),
  AlertModel(id: 4, type: "Autre", message: "Problème technique signalé."),
];
