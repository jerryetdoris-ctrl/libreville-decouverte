import 'package:flutter/material.dart';
import '../models/lieu.dart';
import '../utils/constants.dart';

class LieuCard extends StatelessWidget {
  final Lieu lieu;
  final bool estFavori;
  final VoidCallback onFavori;
  final VoidCallback? onTap;

  const LieuCard({
    super.key,
    required this.lieu,
    required this.estFavori,
    required this.onFavori,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fiche détail à venir')),
              );
            },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.vertCanope.withValues(alpha: 0.12),
                  image: lieu.photoUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(lieu.photoUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: lieu.photoUrl.isEmpty
                    ? Icon(Icons.image, color: AppColors.vertCanope)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lieu.nom,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(
                      lieu.acces,
                      style: TextStyle(
                          fontSize: 12, color: AppColors.terreOkoume),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  estFavori ? Icons.favorite : Icons.favorite_border,
                  color: AppColors.orEquatorial,
                ),
                onPressed: onFavori,
              ),
            ],
          ),
        ),
      ),
    );
  }
}