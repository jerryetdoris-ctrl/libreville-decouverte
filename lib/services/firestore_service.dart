import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/lieu.dart';
import '../models/categorie.dart';
import '../models/favori.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  // =====================================================
  // CATEGORIES
  // =====================================================

  Stream<List<Categorie>> getCategories() {
    return _db.collection('categories').snapshots().map((snapshot) {

      return snapshot.docs.map((doc) {

        return Categorie.fromMap(
          doc.id,
          doc.data(),
        );

      }).toList();

    });
  }



  // =====================================================
  // LIEUX
  // =====================================================

  Stream<List<Lieu>> getLieux() {

    return _db.collection('lieux').snapshots().map((snapshot) {

      return snapshot.docs.map((doc) {

        return Lieu.fromMap(
          doc.id,
          doc.data(),
        );

      }).toList();

    });

  }



  Stream<List<Lieu>> getLieuxParCategorie(
      String categorieId) {

    return _db
        .collection('lieux')
        .where(
          'categorieId',
          isEqualTo: categorieId,
        )
        .snapshots()
        .map((snapshot) {


      return snapshot.docs.map((doc) {


        return Lieu.fromMap(
          doc.id,
          doc.data(),
        );


      }).toList();


    });

  }



  Future<Lieu?> getLieuParId(String lieuId) async {

    final doc = await _db
        .collection('lieux')
        .doc(lieuId)
        .get();


    if (!doc.exists) {
      return null;
    }


    return Lieu.fromMap(
      doc.id,
      doc.data()!,
    );

  }




  // =====================================================
  // FAVORIS
  // =====================================================


  Stream<List<Favori>> getFavoris(
      String utilisateurId) {


    return _db
        .collection('favoris')
        .where(
          'utilisateurId',
          isEqualTo: utilisateurId,
        )
        .snapshots()
        .map((snapshot) {


      return snapshot.docs.map((doc) {


        return Favori.fromMap(
          doc.id,
          doc.data(),
        );


      }).toList();


    });

  }





  Future<void> ajouterFavori(
      String utilisateurId,
      String lieuId) async {


    final favori = Favori(

      id: '',

      lieuId: lieuId,

      utilisateurId: utilisateurId,

      dateAjout: DateTime.now(),

    );


    await _db
        .collection('favoris')
        .add(
          favori.toMap(),
        );


  }





  Future<void> supprimerFavori(
      String favoriId) async {


    await _db
        .collection('favoris')
        .doc(favoriId)
        .delete();


  }





  // =====================================================
  // VERIFIER SI UN LIEU EST DEJA EN FAVORI
  // =====================================================


  Future<String?> idFavoriExistant(
      String utilisateurId,
      String lieuId,
      ) async {


    final snapshot = await _db
        .collection('favoris')
        .where(
          'utilisateurId',
          isEqualTo: utilisateurId,
        )
        .where(
          'lieuId',
          isEqualTo: lieuId,
        )
        .limit(1)
        .get();



    if (snapshot.docs.isEmpty) {

      return null;

    }



    return snapshot.docs.first.id;

  }


}