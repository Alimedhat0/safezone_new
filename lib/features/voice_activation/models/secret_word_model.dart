class SecretWordModel {
  final String uid;
  final String path;

  SecretWordModel({required this.uid, required this.path});

  factory SecretWordModel.fromMap(Map<String, dynamic> map) {
    return SecretWordModel(uid: map['uid'], path: map['path']);
  }

  Map<String, dynamic> toMap() => {'uid': uid, 'path': path};
}
