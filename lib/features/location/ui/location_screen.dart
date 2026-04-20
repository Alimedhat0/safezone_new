// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:provider/provider.dart';
// import 'package:safe_zone/features/home/data/gird_services_data.dart';

// class LocationScreen extends StatefulWidget {
//   const LocationScreen({super.key});

//   @override
//   State<LocationScreen> createState() => _LocationScreenState();
// }

// class _LocationScreenState extends State<LocationScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       context.read<GirdServicesData>().startLiveTracking();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => GirdServicesData()..startLiveTracking(),
//       child: Consumer<GirdServicesData>(
//         builder: (context, loc, _) {
//           if (loc.currentLatLng == null) {
//             return Center(child: CircularProgressIndicator());
//           }
//           return FlutterMap(
//             options: MapOptions(
//               initialCenter: loc.currentLatLng!,
//               initialZoom: 16,
//             ),

//             children: [
//               TileLayer(
//                 urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                 userAgentPackageName: 'com.example.safe_zone',
//               ),
//               SizedBox(
//                 width: double.infinity,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                       ),
//                       onPressed: () {
//                         loc.stopTracking();
//                       },
//                       child: Text(
//                         'Stop Tracking',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               PolylineLayer(
//                 polylines: [
//                   Polyline(
//                     points: loc.path,
//                     strokeWidth: 4,
//                     color: Colors.blue,
//                   ),
//                 ],
//               ),
//               MarkerLayer(
//                 markers: [
//                   Marker(
//                     point: loc.currentLatLng!,
//                     width: 40,
//                     height: 40,
//                     child: Icon(
//                       Icons.person_pin_circle,
//                       size: 40,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ],
//               ),
//               PolygonLayer(
//                 polygons: [
//                   Polygon(points: [loc.currentLatLng!]),
//                 ],
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

// class LocationScreen extends StatefulWidget {
//   const LocationScreen({super.key});

//   @override
//   _LocationScreenState createState() => _LocationScreenState();
// }

// class _LocationScreenState extends State<LocationScreen> {
//   final String apiKey = '57dF8RhOS3GI6MFXdI0A'; // ضع المفتاح بتاعك هنا
//   final MapController mapController = MapController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('خريطة Maptiler')),
//       body: FlutterMap(
//         mapController: mapController,
//         options: MapOptions(
//           initialCenter: LatLng(30.0444, 31.2357), // القاهرة
//           initialZoom: 13,
//           maxZoom: 19,
//           minZoom: 3,
//         ),
//         children: [
//           // 🔹 طبقة الخريطة الأساسية من Maptiler
//           TileLayer(
//             urlTemplate:
//                 'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key={apiKey}',
//             additionalOptions: {'apiKey': apiKey},
//             userAgentPackageName: 'com.example.app',
//             maxNativeZoom: 19,
//             maxZoom: 19,
//           ),

//           // 🔹 لو عايز خرائط هجينة (satellite + streets)
//           // TileLayer(
//           //   urlTemplate: 'https://api.maptiler.com/maps/hybrid/{z}/{x}/{y}.jpg?key={apiKey}',
//           //   additionalOptions: {'apiKey': apiKey},
//           // ),

//           // 🔹 لو عايز الخريطة بالعربي (أسماء المدن بالعربية)
//           // TileLayer(
//           //   urlTemplate: 'https://api.maptiler.com/maps/streets-ar/{z}/{x}/{y}.png?key={apiKey}',
//           //   additionalOptions: {'apiKey': apiKey},
//           // ),

//           // 🔹 إضافة علامة (Marker)
//           MarkerLayer(
//             markers: [
//               Marker(
//                 point: LatLng(30.0444, 31.2357),
//                 width: 80,
//                 height: 80,
//                 child: Icon(Icons.location_pin, color: Colors.red, size: 40),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maptiler_flutter/maptiler_flutter.dart';

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

  final Map<String, String> mapStyles = {
    'streets': 'خريطة شوارع',
    'hybrid': 'هجينة',
    'satellite': 'قمر صناعي',
    'streets-ar': 'شوارع عربية',
    'topo': 'تضاريس',
  };

  @override
  void initState() {
    super.initState();
    MapTilerConfig.setApiKey(apiKey);
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });

      mapController.move(currentLocation!, 15);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedMapStyle = value;
              });
            },
            itemBuilder: (context) {
              return mapStyles.entries.map((entry) {
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

          // أزرار التحكم
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
