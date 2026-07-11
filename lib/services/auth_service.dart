import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Permet d'écouter en direct si un utilisateur est connecté ou non
  Stream<User?> get utilisateurActuel => _auth.authStateChanges();

  User? get utilisateurConnecte => _auth.currentUser;

  Future<UserCredential> inscription({
    required String email,
    required String motDePasse,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: motDePasse,
      );
    } on FirebaseAuthException catch (e) {
      throw _messageErreur(e);
    }
  }

  Future<UserCredential> connexion({
    required String email,
    required String motDePasse,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: motDePasse,
      );
    } on FirebaseAuthException catch (e) {
      throw _messageErreur(e);
    }
  }

  Future<void> deconnexion() async {
    await _auth.signOut();
  }

  // Transforme les codes d'erreur techniques de Firebase
  // en messages compréhensibles pour l'utilisateur
  String _messageErreur(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Un compte existe déjà avec cet email.';
      case 'invalid-email':
        return 'L\'adresse email n\'est pas valide.';
      case 'weak-password':
        return 'Le mot de passe doit contenir au moins 6 caractères.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email ou mot de passe incorrect.';
      default:
        return 'Une erreur est survenue. Réessaie.';
    }
  }
}