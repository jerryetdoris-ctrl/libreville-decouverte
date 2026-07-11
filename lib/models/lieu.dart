import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Lieu {
  final String id;
  final String nom;
  final String description;
  final String categorieId;
  final GeoPoint localisation;
  final String horaires;
  final String photoUrl;
  final String acces;
  final bool incontournable;

  double get latitude => localisation.latitude;
  double get longitude => localisation.longitude;

  Lieu({
    required this.id,
    required this.nom,
    required this.description,
    required this.categorieId,
    required this.localisation,
    required this.horaires,
    required this.photoUrl,
    required this.acces,
    this.incontournable = false,
  });


  factory Lieu.fromMap(String id, Map<String, dynamic> data) {

    debugPrint("Chargement lieu : $data");

    return Lieu(
      id: id,

      nom: (data['nom'] ?? '').toString(),

      description:
          (data['description'] ?? '').toString(),

      categorieId:
          (data['categorieId'] ?? '').toString(),


      localisation: data['localisation'] is GeoPoint
          ? data['localisation'] as GeoPoint
          : const GeoPoint(0, 0),


      horaires:
          (data['horaires'] ?? '').toString(),


      photoUrl:
          _nettoyerUrl(data['photoUrl']),


      acces:
          (data['acces'] ?? '').toString(),


      incontournable:
          data['incontournable'] == true,
    );
  }


  static String _nettoyerUrl(dynamic url) {

    if (url == null) return '';

    String valeur = url.toString();

    // Correction automatique des erreurs de guillemets Firestore
    valeur = valeur.replaceAll('"', '');
    valeur = valeur.replaceAll(',', '');

    return valeur.trim();
  }


  Map<String, dynamic> toMap() {

    return {

      'nom': nom,

      'description': description,

      'categorieId': categorieId,

      'localisation': localisation,

      'horaires': horaires,

      'photoUrl': photoUrl,

      'acces': acces,

      'incontournable': incontournable,

    };
  }
}