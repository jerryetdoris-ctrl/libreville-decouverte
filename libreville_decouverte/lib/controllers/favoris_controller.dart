import 'package:flutter/foundation.dart';
import '../models/favori.dart';
import '../services/firestore_service.dart';

class FavorisController extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Favori> _favoris = [];
  String? _utilisateurId;

  List<Favori> get favoris => _favoris;

  List<String> get lieuxIdsFavoris =>
      _favoris.map((favori) => favori.lieuId).toList();

  // Appelée une fois que l'utilisateur est connu (après connexion),
  // pour démarrer l'écoute de SES favoris précisément.
  void initialiser(String utilisateurId) {
    if (_utilisateurId == utilisateurId) return; // déjà initialisé
    _utilisateurId = utilisateurId;
    _firestoreService.getFavoris(utilisateurId).listen((favoris) {
      _favoris = favoris;
      notifyListeners();
    });
  }

  bool estFavori(String lieuId) {
    return _favoris.any((favori) => favori.lieuId == lieuId);
  }

  Future<void> basculerFavori(String lieuId) async {
    if (_utilisateurId == null) return;

    final idExistant =
        await _firestoreService.idFavoriExistant(_utilisateurId!, lieuId);

    if (idExistant != null) {
      await _firestoreService.supprimerFavori(idExistant);
    } else {
      await _firestoreService.ajouterFavori(_utilisateurId!, lieuId);
    }
    // Pas besoin de notifyListeners() ici : le Stream de getFavoris()
    // va automatiquement recevoir la mise à jour depuis Firestore.
  }
}