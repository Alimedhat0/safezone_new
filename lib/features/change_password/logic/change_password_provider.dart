import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePasswordProvider extends ChangeNotifier {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Future<void> updatePassword(
    String newPassword,
    String currentPassword,
  ) async {
    isLoading = true;
    notifyListeners();
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }

      final email = user.email!;

      // 🔐 1. Re-auth
      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // 🔑 2. Update password
      await user.updatePassword(newPassword);
      Fluttertoast.showToast(msg: "Password updated successfully");

      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      // 🎉 Success
      print("Password updated successfully");
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
    isLoading = false;
    notifyListeners();
  }
}
