import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/itineraire.dart';
import '../services/directions_service.dart';

enum EtatLocalisation {
  enAttente,
  autorisee,
  refusee,
  refuseeDefinitivement,
  serviceDesactive,
}

class NavigationController extends ChangeNotifier {
  final DirectionsService _directionsService = DirectionsService();

  LatLng? _positionActuelle;
  Itineraire? _itineraire;
  EtatLocalisation _etatLocalisation = EtatLocalisation.enAttente;
  bool _chargementItineraire = false;
  String? _erreur;

  LatLng? get positionActuelle => _positionActuelle;
  Itineraire? get itineraire => _itineraire;
  EtatLocalisation get etatLocalisation => _etatLocalisation;
  bool get chargementItineraire => _chargementItineraire;
  String? get erreur => _erreur;

  // À appeler dès l'ouverture de l'écran carte : vérifie les permissions,
  // puis démarre l'écoute en direct de la position si tout est en ordre.
  Future<void> demarrerLocalisation() async {
    final serviceActif = await Geolocator.isLocationServiceEnabled();
    if (!serviceActif) {
      _etatLocalisation = EtatLocalisation.serviceDesactive;
      notifyListeners();
      return;
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      _etatLocalisation = EtatLocalisation.refuseeDefinitivement;
      notifyListeners();
      return;
    }

    if (permission == LocationPermission.denied) {
      _etatLocalisation = EtatLocalisation.refusee;
      notifyListeners();
      return;
    }

    _etatLocalisation = EtatLocalisation.autorisee;
    notifyListeners();

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 15, // ne recalcule pas à chaque centimètre parcouru
      ),
    ).listen((position) {
      _positionActuelle = LatLng(position.latitude, position.longitude);
      notifyListeners();
    });
  }

  Future<void> calculerItineraireVers(LatLng destination) async {
    if (_positionActuelle == null) {
      _erreur = 'Position actuelle inconnue pour le moment.';
      notifyListeners();
      return;
    }

    _chargementItineraire = true;
    _erreur = null;
    notifyListeners();

    final resultat = await _directionsService.calculerItineraire(
      depart: _positionActuelle!,
      destination: destination,
    );

    if (resultat == null) {
      _erreur = 'Itinéraire indisponible pour le moment.';
    } else {
      _itineraire = resultat;
    }

    _chargementItineraire = false;
    notifyListeners();
  }

  void reinitialiserItineraire() {
    _itineraire = null;
    _erreur = null;
    notifyListeners();
  }
}