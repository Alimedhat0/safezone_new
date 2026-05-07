class SecretWordModel {
  final String uid;
  final String path;
  final String keyword;
  final String? id;
  final int createdAt;

  SecretWordModel({
    required this.id,
    required this.uid,
    required this.path,
    required this.keyword,
    required this.createdAt,
  });

  factory SecretWordModel.fromMap(Map<String, dynamic> map, String id) {
    return SecretWordModel(
      uid: map['uid'],
      path: map['path'],
      keyword: (map['keyword'] ?? '').toString(),
      id: id,
      createdAt: map['createdAt'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'path': path,
        'keyword': keyword,
        'id': id,
        'createdAt': createdAt,
      };
}
