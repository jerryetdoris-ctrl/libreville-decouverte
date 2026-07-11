import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/itineraire.dart';

class DirectionsService {
  static const _baseUrl = 'https://router.project-osrm.org/route/v1/driving';

  Future<Itineraire?> calculerItineraire({
    required LatLng depart,
    required LatLng destination,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/${depart.longitude},${depart.latitude};'
      '${destination.longitude},${destination.latitude}'
      '?overview=full&geometries=geojson',
    );

    try {
      final reponse = await http.get(url).timeout(const Duration(seconds: 10));

      if (reponse.statusCode != 200) return null;

      final data = jsonDecode(reponse.body);
      if (data['code'] != 'Ok' || (data['routes'] as List).isEmpty) {
        return null;
      }

      final route = data['routes'][0];
      final coordonnees = route['geometry']['coordinates'] as List;

      // OSRM renvoie chaque point sous la forme [longitude, latitude],
      // alors que LatLng attend (latitude, longitude) : il faut inverser.
      final pointsTrajet = coordonnees.map<LatLng>((point) {
        final lon = (point[0] as num).toDouble();
        final lat = (point[1] as num).toDouble();
        return LatLng(lat, lon);
      }).toList();

      final distanceMetres = (route['distance'] as num).toDouble();
      final dureeSecondes = (route['duration'] as num).toDouble();

      return Itineraire(
        depart: depart,
        destination: destination,
        pointsTrajet: pointsTrajet,
        distanceKm: distanceMetres / 1000,
        dureeMin: (dureeSecondes / 60).round(),
      );
    } catch (e) {
      // Timeout, pas de réseau, ou réponse inattendue : on échoue
      // silencieusement plutôt que de faire planter l'écran carte.
      return null;
    }
  }
}