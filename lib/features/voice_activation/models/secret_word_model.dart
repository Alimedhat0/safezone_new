class SecretWordModel {
  final String uid;
  final String path;
  final String? id;

  SecretWordModel({required this.id, required this.uid, required this.path});

  factory SecretWordModel.fromMap(Map<String, dynamic> map, String id) {
    return SecretWordModel(uid: map['uid'], path: map['path'], id: id);
  }

  Map<String, dynamic> toMap() => {'uid': uid, 'path': path, 'id': id};
}
