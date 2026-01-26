class Agent {
  final String? imageUrl;
  final String firstName;
  final String lastName;
  final String matricule;
  final String phone;
  final String email;

  Agent({
    this.imageUrl,
    required this.firstName,
    required this.lastName,
    required this.matricule,
    required this.phone,
    required this.email,
  });

  String get fullName => '$firstName $lastName';

  // Mock data
  static Agent get mockAgent => Agent(
    imageUrl: null, // null pour utiliser le logo par défaut
    firstName: 'Jean',
    lastName: 'Dupont',
    matricule: 'SEC-2024-001',
    phone: '+33 6 12 34 56 78',
    email: 'jean.dupont@capsecure.fr',
  );
}
