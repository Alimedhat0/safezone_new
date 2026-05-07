import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_zone/features/home/data/gird_services_data.dart';
import 'package:safe_zone/features/notification/logic/notification_provider.dart';
import 'package:safe_zone/features/register/model/register_model.dart';
import 'package:safe_zone/main.dart';

class RegisterProvider extends ChangeNotifier {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void register(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    isLoading = true;
    notifyListeners();
    try {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final String uid = result.user?.uid ?? '';
      RegisterModel registerModel = RegisterModel(
        uid: uid,
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        // isFav: false,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(registerModel.toMap());
      Fluttertoast.showToast(msg: 'Registered Successfully');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainApp()),
      );
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final girdServices = GirdServicesData();
        await girdServices.saveUserUid(user.uid);
        await NotificationProvider().saveCurrentUserFcmToken();
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? 'An error occurred');
    }
    isLoading = false;
    notifyListeners();
  }
}
