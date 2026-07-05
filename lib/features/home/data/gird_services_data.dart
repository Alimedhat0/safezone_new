import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_zone/core/services/location_permission_service.dart';
import 'package:safe_zone/features/home/models/after_sos_model.dart';
import 'package:safe_zone/features/home/models/grid_services_model.dart';
import 'package:safe_zone/features/notification/logic/notification_provider.dart';
import 'package:safe_zone/l10n/generated/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GirdServicesData extends ChangeNotifier {
  static const Duration _liveLocationUpdateInterval = Duration(seconds: 30);
  static const Duration _sosLocationUpdateInterval = Duration(minutes: 1);
  static const int _liveLocationDistanceFilterMeters = 10;

  bool _isGettingCurrentLocation = false;
  bool _isSendingSosLocation = false;
  DateTime? _lastLiveLocationUpdate;
  Timer? _sosLocationTimer;
  AppLocalizations? _sosLocationL10n;

  List<GridServicesModel> localizedGridServices(AppLocalizations l10n) => [
    GridServicesModel(
      image: 'assests/svgs/share.svg',
      title: l10n.share_location,
      subTitle: l10n.send_your_location_to_contacts,
    ),
    GridServicesModel(
      image: 'assests/svgs/map_pin.svg',
      title: l10n.live_tracking,
      subTitle: l10n.last_updated_just_now,
    ),
    GridServicesModel(
      image: 'assests/svgs/vector.svg',
      title: l10n.sms_message,
      subTitle: l10n.send_message_to_police,
    ),
    GridServicesModel(
      image: 'assests/svgs/vector2.svg',
      title: l10n.emergency_call,
      subTitle: l10n.call_emergency_services_directly,
    ),
  ];

  Future<bool> locationPer() async {
    return LocationPermissionService.ensurePermission();
  }

  String? location;
  String? locationName;
  Future<void> getCurrentLocation({AppLocalizations? l10n}) async {
    if (_isGettingCurrentLocation) return;

    _isGettingCurrentLocation = true;
    try {
      final hasPermission = await locationPer();
      if (!hasPermission) return;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentLatLng = LatLng(position.latitude, position.longitude);
      location = '${position.latitude}, ${position.longitude}';
      locationName = await getLocationName(
        position.latitude,
        position.longitude,
        l10n: l10n,
      );
      notifyListeners();
    } catch (e) {
      print('Error with getcurrentlovation:$e');
    } finally {
      _isGettingCurrentLocation = false;
    }
  }

  Future<String> getLocationName(
    double lat,
    double lon, {
    AppLocalizations? l10n,
  }) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);

      if (placemarks.isEmpty) {
        return l10n?.unknown_location ?? "Unknown location";
      }

      Placemark place = placemarks[0];

      return '${place.locality ?? ''}, ${place.country ?? ''}';
    } catch (e) {
      return l10n?.error_getting_location ?? "Error getting location";
    }
  }

  Future<void> shareLocation({AppLocalizations? l10n}) async {
    try {
      await getCurrentLocation(l10n: l10n);
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
  bool get isSosLocationSharingActive => _sosLocationTimer != null;

  Future<void> startLiveTracking() async {
    if (positionStream != null) return;

    final hasPermission = await locationPer();
    if (!hasPermission) {
      return;
    }

    positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: _liveLocationDistanceFilterMeters,
      ),
    ).listen((Position position) {
      final now = DateTime.now();
      if (_lastLiveLocationUpdate != null &&
          now.difference(_lastLiveLocationUpdate!) <
              _liveLocationUpdateInterval) {
        return;
      }

      _lastLiveLocationUpdate = now;
      currentLatLng = LatLng(position.latitude, position.longitude);
      path.add(currentLatLng!);
      notifyListeners();
    });
    notifyListeners();
  }

  void stopTracking() {
    positionStream?.cancel();
    positionStream = null;
    liveLocation = null;
    _lastLiveLocationUpdate = null;
    stopSosLocationSharing();
    print('Stop');
    notifyListeners();
  }

  Future<void> startSosLocationSharing({AppLocalizations? l10n}) async {
    if (_sosLocationTimer != null) return;

    final hasPermission = await locationPer();
    if (!hasPermission) return;

    _sosLocationL10n = l10n;
    await _sendSosLocationUpdate(l10n: l10n);
    _sosLocationTimer = Timer.periodic(_sosLocationUpdateInterval, (_) {
      _sendSosLocationUpdate(l10n: _sosLocationL10n);
    });
    notifyListeners();
  }

  void stopSosLocationSharing() {
    _sosLocationTimer?.cancel();
    _sosLocationTimer = null;
    _sosLocationL10n = null;
  }

  Future<void> _sendSosLocationUpdate({AppLocalizations? l10n}) async {
    if (_isSendingSosLocation) return;

    _isSendingSosLocation = true;
    try {
      final uid =
          FirebaseAuth.instance.currentUser?.uid ?? await getStoredUid();
      if (uid == null) return;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      currentLatLng = LatLng(position.latitude, position.longitude);
      location = '${position.latitude}, ${position.longitude}';
      path.add(currentLatLng!);

      await _sendSosLocationMessageToTrustedContacts(
        senderUid: uid,
        lat: position.latitude,
        lon: position.longitude,
        l10n: l10n,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error sending SOS location update: $e');
    } finally {
      _isSendingSosLocation = false;
    }
  }

  Future<void> _sendSosLocationMessageToTrustedContacts({
    required String senderUid,
    required double lat,
    required double lon,
    AppLocalizations? l10n,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final trustedResult =
        await firestore
            .collection('users')
            .doc(senderUid)
            .collection('trustedContacts')
            .get();

    if (trustedResult.docs.isEmpty) return;

    final senderDoc = await firestore.collection('users').doc(senderUid).get();
    final senderData = senderDoc.data() ?? {};
    final senderName = senderData['name'] ?? '';
    final mapUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    final now = DateTime.now();
    final content =
        l10n?.sos_live_location_update(mapUrl) ??
        'SOS live location update:\n$mapUrl';
    final batch = firestore.batch();

    for (final trustedDoc in trustedResult.docs) {
      final trustedData = trustedDoc.data();
      final messageRef = firestore.collection('messages').doc();

      batch.set(messageRef, {
        'id': messageRef.id,
        'receiverName': trustedData['name'] ?? '',
        'receiverUid': trustedDoc.id,
        'senderName': senderName,
        'senderUid': senderUid,
        'createdAt': now.toString(),
        'content': content,
        'type': 'text',
      });
    }

    await batch.commit();
  }

  void naviagteTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isInit = false;

  Future<void> init() async {
    if (_isInit) return;

    final microphoneStatus = await Permission.microphone.request();
    if (!microphoneStatus.isGranted) {
      print("Microphone permission denied");
      return;
    }

    await _recorder.openRecorder();
    _isInit = true;
  }

  Future<String?> record10Seconds() async {
    if (!_isInit) return null;

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/sos.m4a';

    await _recorder.startRecorder(toFile: path, codec: Codec.aacMP4);

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
  }) async {
    final uid = await getStoredUid();
    if (uid == null) {
      print("No stored UID");
      return;
    }

    final baseUrl = dotenv.env['SOS_API_BASE_URL'] ?? "http://10.0.2.2:3000";
    final uri = Uri.parse("$baseUrl/api/sos");

    var request = http.MultipartRequest("POST", uri);

    request.fields['lat'] = lat.toString();
    request.fields['lon'] = lon.toString();
    request.fields['uid'] = uid;

    request.files.add(await http.MultipartFile.fromPath('audio', audioPath));

    var response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      await NotificationProvider().showNotification();
      print("SOS sent successfully");
    } else {
      print("Failed: ${response.statusCode}");
    }
  }

  Future<void> triggerVoiceSos() async {
    await init();
    if (!_isInit) return;

    final hasPermission = await locationPer();
    if (!hasPermission) return;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    currentLatLng = LatLng(position.latitude, position.longitude);
    await startSosLocationSharing();

    final audioPath = await record10Seconds();
    if (audioPath == null || currentLatLng == null) {
      print("Missing voice SOS data");
      return;
    }

    await sendSos(
      audioPath: audioPath,
      lat: currentLatLng!.latitude,
      lon: currentLatLng!.longitude,
    );
    print('sos sendby speech');
  }

  Future<void> cancelSOS() async {
    stopTracking();
    stopSosLocationSharing();
    currentLatLng = null;
    await _recorder.stopRecorder();
  }

  List<AfterSosModel> localizedAfterSos(AppLocalizations l10n) => [
    AfterSosModel(
      title: l10n.emergency_contacts_notified,
      subtitle: l10n.contacts_received_alert,
    ),
    AfterSosModel(
      title: l10n.live_location_sharing_active,
      subtitle: l10n.updates_every_30_seconds,
    ),
    AfterSosModel(
      title: l10n.voice_note_shared,
      subtitle: l10n.ten_second_recording_sent,
    ),
  ];
}
