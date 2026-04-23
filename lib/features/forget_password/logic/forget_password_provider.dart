import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading = true;
      notifyListeners();

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      Fluttertoast.showToast(msg: "Password reset link sent to your email");

      emailController.clear();
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? "Error occurred");
    }

    isLoading = false;
    notifyListeners();
  }
}
