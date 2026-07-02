import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maptiler_flutter/maptiler_flutter.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/core/services/location_permission_service.dart';
import 'package:safe_zone/l10n/generated/app_localizations.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final String apiKey = dotenv.env['API_Key_Location']!;
  final MapController mapController = MapController();
  LatLng? currentLocation;
  String selectedMapStyle = 'streets';

  Map<String, String> mapStyles(AppLocalizations l10n) => {
    'streets': l10n.map_style_streets_ar,
    'hybrid': l10n.map_style_hybrid_ar,
    'satellite': l10n.map_style_satellite_ar,
    'streets-ar': l10n.map_style_streets_arabic_ar,
    'topo': l10n.map_style_topo_ar,
  };

  @override
  void initState() {
    super.initState();
    MapTilerConfig.setApiKey(apiKey);
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final hasPermission = await LocationPermissionService.ensurePermission();
    if (!hasPermission) return;

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });

    mapController.move(currentLocation!, 15);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.tr;
    final localizedMapStyles = mapStyles(l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.nav_location),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedMapStyle = value;
              });
            },
            itemBuilder: (context) {
              return localizedMapStyles.entries.map((entry) {
                return PopupMenuItem(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: currentLocation ?? LatLng(30.0444, 31.2357),
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.maptiler.com/maps/$selectedMapStyle/{z}/{x}/{y}.png?key=$apiKey',
                userAgentPackageName: 'com.example.app',
              ),
              if (currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: currentLocation!,
                      width: 80,
                      height: 80,
                      child: Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton.small(
                  child: Icon(Icons.add),
                  onPressed:
                      () => mapController.move(
                        mapController.camera.center,
                        mapController.camera.zoom + 1,
                      ),
                ),
                SizedBox(height: 10),
                FloatingActionButton.small(
                  child: Icon(Icons.remove),
                  onPressed:
                      () => mapController.move(
                        mapController.camera.center,
                        mapController.camera.zoom - 1,
                      ),
                ),
                SizedBox(height: 10),
                FloatingActionButton.small(
                  onPressed: _getCurrentLocation,
                  child: Icon(Icons.my_location),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
