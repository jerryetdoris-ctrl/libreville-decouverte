import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/lieux_controller.dart';
import '../models/lieu.dart';
import '../utils/constants.dart';

class CarteScreen extends StatefulWidget {
  final Lieu? lieuDestination;

  const CarteScreen({super.key, this.lieuDestination});

  @override
  State<CarteScreen> createState() => _CarteScreenState();
}

class _CarteScreenState extends State<CarteScreen> {
  final MapController _mapController = MapController();
  bool _carteCentreeSurPosition = false;
  bool _itineraireInitialDemande = false;

  static const _centreParDefaut = LatLng(0.3901, 9.4544); // Libreville

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NavigationController>().demarrerLocalisation();
    });
  }

  void _selectionnerDestination(Lieu lieu) {
    context
        .read<NavigationController>()
        .calculerItineraireVers(LatLng(lieu.latitude, lieu.longitude));
  }

  @override
  Widget build(BuildContext context) {
    final navController = context.watch<NavigationController>();
    final lieuxController = context.watch<LieuxController>();

    // Dès que la position arrive pour la première fois, on centre la
    // carte dessus une seule fois.
    if (navController.positionActuelle != null && !_carteCentreeSurPosition) {
      _carteCentreeSurPosition = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(navController.positionActuelle!, 14);
      });
    }

    // Si un lieu de destination a été passé en arrivant sur cet écran,
    // on attend que la position soit réellement connue avant de calculer
    // l'itinéraire — plutôt que d'essayer immédiatement au chargement,
    // ce qui échouait avant que le GPS ait eu le temps de répondre.
    if (widget.lieuDestination != null &&
        !_itineraireInitialDemande &&
        navController.positionActuelle != null) {
      _itineraireInitialDemande = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _selectionnerDestination(widget.lieuDestination!);
      });
    }

    return Scaffold(
      body: _construireContenu(navController, lieuxController),
    );
  }

  Widget _construireContenu(
      NavigationController navController, LieuxController lieuxController) {
    switch (navController.etatLocalisation) {
      case EtatLocalisation.enAttente:
        return const Center(child: CircularProgressIndicator());

      case EtatLocalisation.serviceDesactive:
        return _messagePermission(
          icone: Icons.location_off,
          texte: 'Le GPS de ton téléphone est désactivé.',
          libelleBouton: 'Activer la localisation',
          onPressed: () async {
            await Geolocator.openLocationSettings();
          },
        );

      case EtatLocalisation.refuseeDefinitivement:
        return _messagePermission(
          icone: Icons.location_disabled,
          texte:
              'L\'accès à la position a été refusé définitivement. Autorise-le dans les réglages de l\'application.',
          libelleBouton: 'Ouvrir les réglages',
          onPressed: () async {
            await Geolocator.openAppSettings();
          },
        );

      case EtatLocalisation.refusee:
        return _messagePermission(
          icone: Icons.my_location,
          texte: 'La navigation a besoin d\'accéder à ta position.',
          libelleBouton: 'Réessayer',
          onPressed: () =>
              context.read<NavigationController>().demarrerLocalisation(),
        );

      case EtatLocalisation.autorisee:
        return _carte(navController, lieuxController);
    }
  }

  Widget _messagePermission({
    required IconData icone,
    required String texte,
    required String libelleBouton,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 48, color: AppColors.terreOkoume),
            const SizedBox(height: 16),
            Text(texte, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: onPressed, child: Text(libelleBouton)),
          ],
        ),
      ),
    );
  }

  Widget _carte(
      NavigationController navController, LieuxController lieuxController) {
    final position = navController.positionActuelle;
    final itineraire = navController.itineraire;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: position ?? _centreParDefaut,
            initialZoom: 12,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.libreville_decouverte',
            ),
            if (itineraire != null)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: itineraire.pointsTrajet,
                    color: AppColors.bleuLagune,
                    strokeWidth: 4,
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                if (position != null)
                  Marker(
                    point: position,
                    width: 24,
                    height: 24,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.orEquatorial,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                    ),
                  ),
                ...lieuxController.lieuxFiltres.map((lieu) => Marker(
                      point: LatLng(lieu.latitude, lieu.longitude),
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () => _selectionnerDestination(lieu),
                        child: Icon(
                          Icons.location_on,
                          color: AppColors.vertCanope,
                          size: 36,
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: _carteInfoItineraire(navController),
        ),
      ],
    );
  }

  Widget _carteInfoItineraire(NavigationController navController) {
    if (navController.chargementItineraire) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2)),
              SizedBox(width: 12),
              Text('Calcul de l\'itinéraire...'),
            ],
          ),
        ),
      );
    }

    if (navController.erreur != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(navController.erreur!),
        ),
      );
    }

    final itineraire = navController.itineraire;
    if (itineraire == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Touche un lieu sur la carte pour voir l\'itinéraire.'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${itineraire.distanceKm.toStringAsFixed(1)} km',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('${itineraire.dureeMin} min'),
          ],
        ),
      ),
    );
  }
}