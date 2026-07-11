import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/lieux_controller.dart';
import '../controllers/favoris_controller.dart';
import '../utils/constants.dart';
import '../widgets/lieu_card.dart';
import 'detail_lieu_screen.dart';

class AccueilScreen extends StatelessWidget {
  const AccueilScreen({super.key});

  IconData _iconePourCategorie(String icone) {
    switch (icone) {
      case 'nature':
        return Icons.eco;
      case 'plage':
        return Icons.beach_access;
      case 'culture':
        return Icons.museum;
      case 'patrimoine':
        return Icons.church;
      default:
        return Icons.place;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lieuxController = context.watch<LieuxController>();
    final favorisController = context.watch<FavorisController>();

    if (lieuxController.chargement) {
      return const Center(child: CircularProgressIndicator());
    }

    final aucunFiltreActif = lieuxController.categorieSelectionnee == null;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            onChanged: lieuxController.rechercher,
            decoration: InputDecoration(
              hintText: 'Rechercher un lieu...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: lieuxController.categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final categorie = lieuxController.categories[index];
                final selectionnee =
                    lieuxController.categorieSelectionnee == categorie.id;
                return ChoiceChip(
                  label: Text(categorie.nom),
                  avatar: Icon(_iconePourCategorie(categorie.icone), size: 18),
                  selected: selectionnee,
                  selectedColor: AppColors.orEquatorial,
                  backgroundColor: AppColors.bleuLagune.withValues(alpha: 0.15),
                  labelStyle: TextStyle(
                    color: selectionnee
                        ? AppColors.anthraciteEbene
                        : AppColors.bleuLagune,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (_) =>
                      lieuxController.selectionnerCategorie(categorie.id),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          if (aucunFiltreActif) ...[
            Text(
              'À NE PAS MANQUER',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
                color: AppColors.terreOkoume,
              ),
            ),
            const SizedBox(height: 12),
            ...lieuxController.lieuxIncontournables.map((lieu) => LieuCard(
                  lieu: lieu,
                  estFavori: favorisController.estFavori(lieu.id),
                  onFavori: () => favorisController.basculerFavori(lieu.id),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => DetailLieuScreen(lieu: lieu)),
                  ),
                )),
            const SizedBox(height: 24),
            Text(
              'TOUS LES LIEUX',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
                color: AppColors.terreOkoume,
              ),
            ),
            const SizedBox(height: 12),
          ],
          ...lieuxController.lieuxFiltres.map((lieu) => LieuCard(
                lieu: lieu,
                estFavori: favorisController.estFavori(lieu.id),
                onFavori: () => favorisController.basculerFavori(lieu.id),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => DetailLieuScreen(lieu: lieu)),
                ),
              )),
        ],
      ),
    );
  }
}