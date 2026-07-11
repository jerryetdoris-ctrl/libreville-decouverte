class Favori {
  final String id;
  final String lieuId;
  final String utilisateurId;
  final DateTime dateAjout;

  Favori({
    required this.id,
    required this.lieuId,
    required this.utilisateurId,
    required this.dateAjout,
  });

  factory Favori.fromMap(String id, Map<String, dynamic> data) {
    return Favori(
      id: id,
      lieuId: data['lieuId'] ?? '',
      utilisateurId: data['utilisateurId'] ?? '',
      dateAjout: data['dateAjout'] != null
          ? DateTime.parse(data['dateAjout'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lieuId': lieuId,
      'utilisateurId': utilisateurId,
      'dateAjout': dateAjout.toIso8601String(),
    };
  }
}