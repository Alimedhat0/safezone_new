import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_zone/features/home/models/grid_services_model.dart';
import 'package:share_plus/share_plus.dart';

class GirdServicesData extends ChangeNotifier {
  List<GridServicesModel> gridServicesModel = [
    GridServicesModel(
      image: 'assests/svgs/share.svg',
      title: 'Share location',
      subTitle: 'send your location to contacts.',
    ),
    GridServicesModel(
      image: 'assests/svgs/map_pin.svg',
      title: 'Live Tracking',
      subTitle: 'Last updated: Just now',
    ),
    GridServicesModel(
      image: 'assests/svgs/vector.svg',
      title: 'SMS message',
      subTitle: 'send  a message to the police',
    ),
    GridServicesModel(
      image: 'assests/svgs/vector2.svg',
      title: 'Emergency Call',
      subTitle: 'call emergency services directly',
    ),
  ];

  Future<void> locationPer() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      print('per denid');
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      openAppSettings();
    }
  }

  String? location;
  String? locationName;
  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      location = '${position.latitude}, ${position.longitude}';
      locationName = await getLocationName(
        position.latitude,
        position.longitude,
      );
      notifyListeners();
    } catch (e) {
      print('Error with getcurrentlovation:$e');
    }
  }

  Future<String> getLocationName(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);

      if (placemarks.isEmpty) return "Unknown location";

      Placemark place = placemarks[0];

      return '${place.locality ?? ''}, ${place.country ?? ''}';
    } catch (e) {
      return "Error getting location";
    }
  }

  Future<void> shareLocation() async {
    try {
      if (location == null) {
        await locationPer();
        await getCurrentLocation();
      }
      await Share.share(
        'https://www.google.com/maps/search/?api=1&query=$location',
      );
    } catch (e) {
      print('Error with shareLocation:$e');
    }
  }

  StreamSubscription<Position>? positionStream;
  String? liveLocation;
  LatLng? currentLatLng;
  List<LatLng> path = [];

  Future<void> startLiveTracking() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      openAppSettings();
      return;
    }
    positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
      ),
    ).listen((Position position) {
      // currentLatLng = LatLng(pos.latitude, pos.longitude);
      currentLatLng = LatLng(position.latitude, position.longitude);
      notifyListeners();
      path.add(currentLatLng!);
      print('Your Location: $currentLatLng');
    });
    notifyListeners();
  }

  void stopTracking() {
    print('Stop');
    positionStream?.cancel();
    positionStream = null;
    liveLocation = null;
    notifyListeners();
  }

  void naviagteTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  //SoS Functions

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isInit = false;

  Future<void> init() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
    _isInit = true;
  }

  Future<String?> record10Seconds() async {
    if (!_isInit) return null;

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/sos.wav';

    await _recorder.startRecorder(toFile: path, codec: Codec.pcm16WAV);

    await Future.delayed(const Duration(seconds: 11));

    await _recorder.stopRecorder();
    print(
      '------------------------------------------------------------------------------------------$path',
    );
    return path;
  }

  Future<void> disposeRecorder() async {
    await _recorder.closeRecorder();
  }

  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> sendSos({
    required String audioPath,
    required double lat,
    required double lon,
    required String uid,
  }) async {
    final uri = Uri.parse("http://10.0.2.2:3000/api/sos");

    var request = http.MultipartRequest("POST", uri);

    request.fields['lat'] = lat.toString();
    request.fields['lon'] = lon.toString();
    request.fields['uid'] = uid;

    request.files.add(await http.MultipartFile.fromPath('audio', audioPath));

    var response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("SOS sent successfully 🔥");
    } else {
      print("Failed: ${response.statusCode}");
    }
  }
}
