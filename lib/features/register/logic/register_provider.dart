import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        email: emailController.text,
        password: passwordController.text,
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
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? 'An error occurred');
    }
    isLoading = false;
    notifyListeners();
  }
}
