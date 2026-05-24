import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_zone/features/home/models/after_sos_model.dart';
import 'package:safe_zone/features/home/models/grid_services_model.dart';
import 'package:safe_zone/features/notification/logic/notification_provider.dart';
import 'package:safe_zone/features/sos/ui/sos_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      await locationPer();
      await getCurrentLocation();
      if (location != null) {
        await Share.share(
          'https://www.google.com/maps/search/?api=1&query=$location',
        );
      }
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
      // print('Your Location: $currentLatLng');
    });
    notifyListeners();
  }

  void stopTracking() {
    positionStream?.cancel();
    positionStream = null;
    liveLocation = null;
    print('Stop');
    notifyListeners();
  }

  void naviagteTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  //SoS Functions

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isInit = false;

  Future<void> init() async {
    if (_isInit) return;

    final microphoneStatus = await Permission.microphone.request();
    if (!microphoneStatus.isGranted) {
      print("❌ Microphone permission denied");
      return;
    }

    await _recorder.openRecorder();
    _isInit = true;
  }

  Future<String?> record10Seconds() async {
    if (!_isInit) return null;

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/sos.m4a';

    await _recorder.startRecorder(
      toFile: path,
      codec: Codec.aacMP4,
      // sampleRate: 44100,
      // numChannels: 1,
    );

    await Future.delayed(const Duration(seconds: 11));

    await _recorder.stopRecorder();
    print(
      '--------------------------------------------------------------------------------$path',
    );
    print(File(path).lengthSync());
    return path;
  }

  Future<void> disposeRecorder() async {
    await _recorder.closeRecorder();
  }

  Future<void> saveUserUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("uid", uid);
  }

  Future<String?> getStoredUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("uid");
  }

  Future<void> sendSos({
    required String audioPath,
    required double lat,
    required double lon,
    // required String uid,
  }) async {
    final uid = await getStoredUid();
    if (uid == null) {
      print("❌ No stored UID");
      return;
    }

    final uri = Uri.parse("http://192.168.1.7:3000/api/sos");

    var request = http.MultipartRequest("POST", uri);

    request.fields['lat'] = lat.toString();
    request.fields['lon'] = lon.toString();
    request.fields['uid'] = uid;

    request.files.add(await http.MultipartFile.fromPath('audio', audioPath));

    var response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      await NotificationProvider().showNotification();
      print("SOS sent successfully 🔥");
    } else {
      print("Failed: ${response.statusCode}");
    }
  }

  Future<void> triggerVoiceSos() async {
    await init();
    if (!_isInit) return;

    await locationPer();

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    currentLatLng = LatLng(position.latitude, position.longitude);

    final audioPath = await record10Seconds();
    if (audioPath == null || currentLatLng == null) {
      print("Missing voice SOS data ❌");
      return;
    }

    await sendSos(
      audioPath: audioPath,
      lat: currentLatLng!.latitude,
      lon: currentLatLng!.longitude,
    );
    print('sos sendby speech');
  }

  Future<void> cancelSOS() async {}

  List<AfterSosModel> afterSos = [
    AfterSosModel(
      title: 'Emergency contacts notified',
      subtitle: 'contacts received your alert',
    ),
    AfterSosModel(
      title: 'Live location sharing active',
      subtitle: 'Updates every 30 seconds',
    ),
    AfterSosModel(
      title: 'Voice note shared',
      subtitle: '10 second recording sent',
    ),
  ];
}
