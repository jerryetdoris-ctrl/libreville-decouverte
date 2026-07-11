import 'package:flutter/foundation.dart';
import '../models/lieu.dart';
import '../models/categorie.dart';
import '../services/firestore_service.dart';

class LieuxController extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Lieu> _tousLesLieux = [];
  List<Categorie> _categories = [];
  String? _categorieSelectionnee;
  String _rechercheTexte = '';
  bool _chargement = true;

  bool get chargement => _chargement;
  List<Categorie> get categories => _categories;
  String? get categorieSelectionnee => _categorieSelectionnee;

  // Applique le filtre de catégorie ET la recherche texte en même temps,
  // pour que l'écran n'ait qu'une seule liste à afficher, déjà filtrée.
  List<Lieu> get lieuxFiltres {
    var resultat = _tousLesLieux;

    if (_categorieSelectionnee != null) {
      resultat = resultat
          .where((lieu) => lieu.categorieId == _categorieSelectionnee)
          .toList();
    }

    if (_rechercheTexte.isNotEmpty) {
      final recherche = _rechercheTexte.toLowerCase();
      resultat = resultat
          .where((lieu) => lieu.nom.toLowerCase().contains(recherche))
          .toList();
    }

    return resultat;
  }

  List<Lieu> get lieuxIncontournables {
    return _tousLesLieux.where((lieu) => lieu.incontournable).toList();
  }

  LieuxController() {
    _ecouterLieux();
    _ecouterCategories();
  }

  void _ecouterLieux() {
    _firestoreService.getLieux().listen((lieux) {
      _tousLesLieux = lieux;
      _chargement = false;
      notifyListeners();
    });
  }

  void _ecouterCategories() {
    _firestoreService.getCategories().listen((categories) {
      _categories = categories;
      notifyListeners();
    });
  }

  void selectionnerCategorie(String? categorieId) {
    // Cliquer une deuxième fois sur la même catégorie la désélectionne
    _categorieSelectionnee =
        _categorieSelectionnee == categorieId ? null : categorieId;
    notifyListeners();
  }

  void rechercher(String texte) {
    _rechercheTexte = texte;
    notifyListeners();
  }

  String get rechercheTexte => _rechercheTexte;

  void reinitialiserFiltres() {
    if (_categorieSelectionnee != null || _rechercheTexte.isNotEmpty) {
      _categorieSelectionnee = null;
      _rechercheTexte = '';
      notifyListeners();
    }
  }

  Lieu? lieuParId(String id) {
    try {
      return _tousLesLieux.firstWhere((lieu) => lieu.id == id);
    } catch (_) {
      return null;
    }
  }
}