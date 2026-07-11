import 'package:latlong2/latlong.dart';

class Itineraire {
  final LatLng depart;
  final LatLng destination;
  final List<LatLng> pointsTrajet;
  final double distanceKm;
  final int dureeMin;

  Itineraire({
    required this.depart,
    required this.destination,
    required this.pointsTrajet,
    required this.distanceKm,
    required this.dureeMin,
  });
}