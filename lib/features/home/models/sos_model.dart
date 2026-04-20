class SosModel {
  final String uid;
  final String name;
  final DateTime timestamp;
  final String sosMsg;
  final double lat;
  final double lon;
  final String voiceNoteUrl;

  SosModel({
    required this.uid,
    required this.name,
    required this.timestamp,
    required this.sosMsg,
    required this.lat,
    required this.lon,
    required this.voiceNoteUrl,
  });

  factory SosModel.fromMap(Map<String, dynamic> map) => SosModel(
    uid: map['uid'],
    name: map['name'],
    timestamp: map['timestamp'],
    sosMsg: map['sosMsg'],
    lat: map['lat'],
    lon: map['lon'],
    voiceNoteUrl: map['voiceNotePath'],
  );

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'timestamp': timestamp,
    'sosMsg': sosMsg,
    'lat': lat,
    'lon': lon,
    'voiceNotePath': voiceNoteUrl,
  };
}
