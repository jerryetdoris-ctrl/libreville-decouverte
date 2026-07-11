import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libreville_decouverte/models/lieu.dart';

void main() {
  group('Lieu.fromMap', () {
    test('interprète correctement un document complet', () {
      final data = {
        'nom': 'Pointe-Denis',
        'description': 'Plage de sable fin.',
        'categorieId': 'plages',
        'localisation': const GeoPoint(0.5333, 9.3),
        'horaires': 'Accès libre',
        'photoUrl': '',
        'acces': '25 min en bateau',
        'incontournable': true,
      };

      final lieu = Lieu.fromMap('lieu1', data);

      expect(lieu.nom, 'Pointe-Denis');
      expect(lieu.categorieId, 'plages');
      expect(lieu.latitude, 0.5333);
      expect(lieu.longitude, 9.3);
      expect(lieu.incontournable, true);
    });

    test('applique des valeurs par défaut si des champs manquent', () {
      final lieu = Lieu.fromMap('lieu2', {'nom': 'Lieu incomplet'});

      expect(lieu.nom, 'Lieu incomplet');
      expect(lieu.description, '');
      expect(lieu.incontournable, false);
      expect(lieu.latitude, 0);
    });
  });
}