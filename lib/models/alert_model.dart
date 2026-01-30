import 'package:equatable/equatable.dart';

class AlertModel extends Equatable {
  final int id;
  final String type;
  final String message;

  const AlertModel({
    required this.id,
    required this.type,
    required this.message,
  });

  // Créer AlertModel depuis JSON
  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as int,
      type: json['type'] as String,
      message: json['message'] as String,
    );
  }

  // Convertir AlertModel en JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'type': type, 'message': message};
  }

  @override
  List<Object> get props => [id, type, message];
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
