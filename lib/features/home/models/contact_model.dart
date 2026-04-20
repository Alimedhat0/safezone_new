class ContactModel {
  final String name;
  final String phone;
  final String uid;

  ContactModel({required this.name, required this.phone, required this.uid});

  factory ContactModel.fromMap(Map<String, dynamic> map) =>
      ContactModel(name: map['name'], phone: map['phone'], uid: map['uid']);

  Map<String, dynamic> toMap() => {'name': name, 'phone': phone, 'uid': uid};
}
