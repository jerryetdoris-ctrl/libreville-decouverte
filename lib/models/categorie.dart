class Categorie {
  final String id;
  final String nom;
  final String icone;

  Categorie({
    required this.id,
    required this.nom,
    required this.icone,
  });

  factory Categorie.fromMap(String id, Map<String, dynamic> data) {
    return Categorie(
      id: id,
      nom: data['nom'] ?? '',
      icone: data['icone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'icone': icone,
    };
  }
}