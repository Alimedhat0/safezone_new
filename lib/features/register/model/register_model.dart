class RegisterModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  bool isTrusted;

  RegisterModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.isTrusted = false,
  });

  factory RegisterModel.fromMap(Map<String, dynamic> map) {
    return RegisterModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      isTrusted: map['isTrusted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'email': email,
    'phone': phone,
    'isTrusted': isTrusted,
  };
}

RegisterModel? registerModel;
