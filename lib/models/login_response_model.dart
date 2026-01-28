import 'package:equatable/equatable.dart';

class LoginResponseModel extends Equatable {
  final String token;
  final bool isFirstLogin;
  final AgentModel agent;
  final bool status;

  const LoginResponseModel({
    required this.token,
    required this.isFirstLogin,
    required this.agent,
    required this.status,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] ?? '',
      isFirstLogin: json['is_first_login'] ?? false,
      agent: AgentModel.fromJson(json['agent'] ?? {}),
      status: json['status'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'is_first_login': isFirstLogin,
      'agent': agent.toJson(),
      'status': status,
    };
  }

  @override
  List<Object?> get props => [token, isFirstLogin, agent, status];
}

class AgentModel extends Equatable {
  final int id;
  final String name;
  final String firstName;
  final String email;
  final String phone;
  final String registrationNumber;
  final String? imageUrl;

  const AgentModel({
    required this.id,
    required this.name,
    required this.firstName,
    required this.email,
    required this.phone,
    required this.registrationNumber,
    this.imageUrl,
  });

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      firstName: json['first_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      registrationNumber: json['registration_number'] ?? '',
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'first_name': firstName,
      'email': email,
      'phone': phone,
      'registration_number': registrationNumber,
      'image_url': imageUrl,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    firstName,
    email,
    phone,
    registrationNumber,
    imageUrl,
  ];
}
