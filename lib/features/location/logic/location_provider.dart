// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:latlong2/latlong.dart';

// class LocationProvider extends ChangeNotifier {
//   StreamSubscription<Position>? sub;
//   LatLng? currentLatLng;
//   List<LatLng> path = [];

//   Future<void> startTracking() async {
//     sub = Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.best,
//         distanceFilter: 1,
//       ),
//     ).listen((pos) {
//       currentLatLng = LatLng(pos.latitude, pos.longitude);
//       path.add(currentLatLng!);
//       notifyListeners();
//     });
//   }

//   void stopTracking() {
//     sub?.cancel();
//     sub = null;
//   }
// }
