import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_zone/features/home/models/contact_model.dart';
import 'package:safe_zone/features/home/ui/second_home_screen.dart';
import 'package:safe_zone/features/location/ui/location_screen.dart';
import 'package:safe_zone/features/profile/ui/profile_screen.dart';
import 'package:safe_zone/features/register/model/register_model.dart';
import 'package:safe_zone/features/services/ui/services_screen.dart';
import 'package:safe_zone/features/settings/ui/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  RegisterModel? registerModel;
  List<Widget> get screens => [
    SecondHomeScreen(registerModel: registerModel),
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
  Future<void> getAllUsers() async {
    isLoading = true;
    notifyListeners();

    final result =
        await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get();

    users =
        result.docs.map((doc) => RegisterModel.fromMap(doc.data())).toList();

    await getTrustedUsers();

    isLoading = false;
    notifyListeners();
  }

  Future<void> getTrustedUsers() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final result =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('trustedContacts')
            .get();

    users =
        users.map((user) {
          user.isTrusted = result.docs.any((doc) => doc.id == user.uid);
          return user;
        }).toList();
    trustedContacts =
        result.docs.map((doc) => RegisterModel.fromMap(doc.data())).toList();
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
    nameController.clear();
    phoneController.clear();
    notifyListeners();
  }

  Future<void> toggleTrusted(RegisterModel user) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final trustedRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('trustedContacts')
        .doc(user.uid);

    if (trustedContacts.any((u) => u.uid == user.uid)) {
      trustedContacts.removeWhere((u) => u.uid == user.uid);
      user.isTrusted = false;
      await trustedRef.delete();
    } else {
      trustedContacts.add(user);
      user.isTrusted = true;
      await trustedRef.set(user.toMap());
    }

    notifyListeners();
  }

  List<RegisterModel> trustedContacts = [];

  Locale locale = Locale('en');

  void changLang(String lang) async {
    locale = Locale(lang);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', lang);
    notifyListeners();
  }

  void loadLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('lang');
    if (lang != null) {
      locale = Locale(lang);
      notifyListeners();
    }
  }

  ThemeMode themeMode = ThemeMode.light;

  void toggleTheme(bool isDark) async {
    await changeTheme(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> changeTheme(ThemeMode mode) async {
    themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.name);
    await prefs.setBool('isDark', mode == ThemeMode.dark);
  }

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('themeMode');
    if (savedTheme == ThemeMode.dark.name) {
      themeMode = ThemeMode.dark;
    } else if (savedTheme == ThemeMode.light.name) {
      themeMode = ThemeMode.light;
    } else {
      final isDark = prefs.getBool('isDark') ?? false;
      themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    }
    notifyListeners();
  }
}
