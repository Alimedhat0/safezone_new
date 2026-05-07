import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';
import 'package:safe_zone/features/register/model/register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileProvider extends ChangeNotifier {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Future<void> editProfile(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    isLoading = true;
    notifyListeners();
    try {
      final user = FirebaseAuth.instance.currentUser!;
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': nameController.text,
        'phone': phoneController.text,
      });
      await context.read<HomeProvider>().getUser();
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: 'Profile updated successfully');
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? 'Unknown error');
    }
  }

  String? imagePath;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      imagePath = image.path;
      await saveImage(image.path);
      notifyListeners();
    }
  }

  Future<void> saveImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', path);
  }

  Future<void> loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    imagePath = prefs.getString('profile_image');
    notifyListeners();
  }

  void init(RegisterModel? model) {
    if (model == null) return;

    nameController.text = model.name;
    phoneController.text = model.phone;

    notifyListeners();
  }
}
