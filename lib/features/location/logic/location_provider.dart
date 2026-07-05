import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:safe_zone/core/services/location_permission_service.dart';

class LocationProvider extends ChangeNotifier {
  final String apiKey = dotenv.env['API_Key_Location']!;
  final MapController mapController = MapController();
  LatLng? currentLocation;
  String selectedMapStyle = 'basic-v2-dark';

  Future<void> getCurrentLocation() async {
    final hasPermission = await LocationPermissionService.ensurePermission();
    if (!hasPermission) return;

    Position position = await Geolocator.getCurrentPosition();

    currentLocation = LatLng(position.latitude, position.longitude);

    moveTo(currentLocation!);
  }

  void moveTo(LatLng location, {double zoom = 15}) {
    currentLocation = location;
    mapController.move(location, zoom);
    notifyListeners();
  }
}
