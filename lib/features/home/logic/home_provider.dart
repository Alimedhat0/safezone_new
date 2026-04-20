import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safe_zone/features/home/models/contact_model.dart';
import 'package:safe_zone/features/home/ui/home_screen.dart';
import 'package:safe_zone/features/location/ui/location_screen.dart';
import 'package:safe_zone/features/profile/ui/profile_screen.dart';
import 'package:safe_zone/features/register/model/register_model.dart';
import 'package:safe_zone/features/services/ui/services_screen.dart';
import 'package:safe_zone/features/settings/ui/settings_screen.dart';

class HomeProvider extends ChangeNotifier {
  RegisterModel? registerModel;
  List<Widget> get screens => [
    HomeScreen(registerModel: registerModel),
    LocationScreen(),
    ServicesScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];
  int currentIndex = 0;
  void channgeIndex(int newIndex) {
    currentIndex = newIndex;
    notifyListeners();
  }

  final searchController = TextEditingController();

  void searchForUser() {
    users =
        users
            .where(
              (element) => element.name.toLowerCase().contains(
                searchController.text.toLowerCase(),
              ),
            )
            .toList();

    notifyListeners();
  }

  List<RegisterModel> users = [];
  bool isLoading = false;
  void getAllUsers() async {
    isLoading = true;
    notifyListeners();

    final result =
        await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get();

    users =
        result.docs.map((doc) => RegisterModel.fromMap(doc.data())).toList();

    isLoading = false;
    notifyListeners();
  }

  void getTrustedUsers() async {
    isLoading = true;
    notifyListeners();

    final result =
        await FirebaseFirestore.instance
            .collection('users')
            .where('isTrusted', isNotEqualTo: false)
            .get();

    users =
        result.docs.map((doc) => RegisterModel.fromMap(doc.data())).toList();

    isLoading = false;
    notifyListeners();
  }

  Future<void> getUser() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final result =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    final data = result.data();
    if (data != null) registerModel = RegisterModel.fromMap(data);
    notifyListeners();
  }

  Future<void> init() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final data = doc.data();

    if (data != null) {
      registerModel = RegisterModel.fromMap(data);
    }

    notifyListeners();
  }

  List<ContactModel> contacts = [];
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  void addContact() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final contact = ContactModel(
      name: nameController.text,
      phone: phoneController.text,
      uid: uid,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('contacts')
        .add(contact.toMap());
    // contacts.add(contact);
    nameController.clear();
    phoneController.clear();
    // getContacts();
    notifyListeners();
  }

  void toggleTrusted(RegisterModel user) {
    if (trustedContacts.any((u) => u.uid == user.uid)) {
      trustedContacts.removeWhere((u) => u.uid == user.uid);
    } else {
      trustedContacts.add(user);
    }

    notifyListeners();
  }

  List<RegisterModel> trustedContacts = [];

  //SOS Functions

  Future<void> sendSos({
    required String audioPath,
    required double lat,
    required double lon,
    required String uid,
  }) async {
    // final uri = Uri.parse("http://192.168.1.5:3000/api/sos");
    final uri = Uri.parse("http://10.0.2.2:3000");

    var request = http.MultipartRequest("POST", uri);

    // 📍 بيانات عادية
    request.fields['lat'] = lat.toString();
    request.fields['lon'] = lon.toString();
    request.fields['uid'] = uid;

    // 🎤 ملف الصوت
    request.files.add(await http.MultipartFile.fromPath('audio', audioPath));

    // 🚀 إرسال
    var response = await request.send();

    if (response.statusCode == 200) {
      print("SOS sent successfully 🔥");
    } else {
      print("Failed: ${response.statusCode}");
    }
  }
}
