class Utilisateur {
  final String uid;
  final String email;
  final String nomAffiche;
  final String methodeConnexion;
  final DateTime dateCreation;

  Utilisateur({
    required this.uid,
    required this.email,
    required this.nomAffiche,
    required this.methodeConnexion,
    required this.dateCreation,
  });

  factory Utilisateur.fromMap(String uid, Map<String, dynamic> data) {
    return Utilisateur(
      uid: uid,
      email: data['email'] ?? '',
      nomAffiche: data['nomAffiche'] ?? '',
      methodeConnexion: data['methodeConnexion'] ?? 'email',
      dateCreation: data['dateCreation'] != null
          ? DateTime.parse(data['dateCreation'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'nomAffiche': nomAffiche,
      'methodeConnexion': methodeConnexion,
      'dateCreation': dateCreation.toIso8601String(),
    };
  }
}