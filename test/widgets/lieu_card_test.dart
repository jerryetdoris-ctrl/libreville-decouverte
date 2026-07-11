import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libreville_decouverte/models/lieu.dart';
import 'package:libreville_decouverte/widgets/lieu_card.dart';

void main() {
  final lieuTest = Lieu(
    id: '1',
    nom: 'Musée National',
    description: 'Un musée.',
    categorieId: 'culture',
    localisation: const GeoPoint(0.39, 9.45),
    horaires: '9h-17h',
    photoUrl: '',
    acces: 'Centre-ville',
    incontournable: true,
  );

  testWidgets('affiche le nom et l\'accès du lieu', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LieuCard(
            lieu: lieuTest,
            estFavori: false,
            onFavori: () {},
          ),
        ),
      ),
    );

    expect(find.text('Musée National'), findsOneWidget);
    expect(find.text('Centre-ville'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });

  testWidgets('affiche un cœur plein si le lieu est en favori', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LieuCard(
            lieu: lieuTest,
            estFavori: true,
            onFavori: () {},
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsNothing);
  });

  testWidgets('déclenche onFavori au clic sur le cœur', (tester) async {
    var appele = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LieuCard(
            lieu: lieuTest,
            estFavori: false,
            onFavori: () => appele = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();

    expect(appele, true);
  });
}