import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/favoris_controller.dart';
import '../controllers/lieux_controller.dart';
import '../models/lieu.dart';
import '../widgets/lieu_card.dart';
import 'detail_lieu_screen.dart';

class FavorisScreen extends StatelessWidget {
  const FavorisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorisController = context.watch<FavorisController>();
    final lieuxController = context.watch<LieuxController>();

    final lieuxFavoris = favorisController.lieuxIdsFavoris
        .map((id) => lieuxController.lieuParId(id))
        .where((lieu) => lieu != null)
        .cast<Lieu>()
        .toList();

    if (lieuxFavoris.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
              'Aucun favori pour l\'instant.\nAjoute des lieux depuis l\'accueil.',
              textAlign: TextAlign.center),
        ),
      );
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: lieuxFavoris
            .map((lieu) => LieuCard(
                  lieu: lieu,
                  estFavori: true,
                  onFavori: () => favorisController.basculerFavori(lieu.id),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => DetailLieuScreen(lieu: lieu)),
                  ),
                ))
            .toList(),
      ),
    );
  }
}