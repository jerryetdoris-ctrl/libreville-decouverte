import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _chargement = false;
  String? _erreur;

  bool get chargement => _chargement;
  String? get erreur => _erreur;
  User? get utilisateurConnecte => _authService.utilisateurConnecte;
  Stream<User?> get etatConnexion => _authService.utilisateurActuel;

  Future<bool> inscription(String email, String motDePasse) async {
    _demarrerChargement();
    try {
      await _authService.inscription(email: email, motDePasse: motDePasse);
      _terminerChargement();
      return true;
    } catch (e) {
      _erreur = e.toString();
      _terminerChargement();
      return false;
    }
  }

  Future<bool> connexion(String email, String motDePasse) async {
    _demarrerChargement();
    try {
      await _authService.connexion(email: email, motDePasse: motDePasse);
      _terminerChargement();
      return true;
    } catch (e) {
      _erreur = e.toString();
      _terminerChargement();
      return false;
    }
  }

  Future<void> deconnexion() async {
    await _authService.deconnexion();
    notifyListeners();
  }

  void _demarrerChargement() {
    _chargement = true;
    _erreur = null;
    notifyListeners();
  }

  void _terminerChargement() {
    _chargement = false;
    notifyListeners();
  }
}