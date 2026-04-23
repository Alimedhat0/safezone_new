import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangeEmailProvider extends ChangeNotifier {
  final newEmailController = TextEditingController();
  final confirmEmailController = TextEditingController();
  final oldEmailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  Future<void> updateEmail(String password) async {
    isLoading = true;
    notifyListeners();
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }

      final currentEmail = user.email;

      if (currentEmail == null) {
        throw Exception("Current email is null");
      }

      final newEmail = newEmailController.text.trim();
      final confirmEmail = confirmEmailController.text.trim();

      // ✅ Validation
      if (newEmail.isEmpty || confirmEmail.isEmpty) {
        throw Exception("Please fill all fields");
      }

      if (newEmail != confirmEmail) {
        throw Exception("Emails do not match");
      }

      // 🔐 1. Re-authentication
      final credential = EmailAuthProvider.credential(
        email: currentEmail,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      await user.verifyBeforeUpdateEmail(newEmail);
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'email': newEmail},
      );
      Fluttertoast.showToast(msg: "Verification email sent to $newEmail");

      newEmailController.clear();
      confirmEmailController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? "Firebase error");
      throw Exception(e.message);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
    isLoading = false;
    notifyListeners();
  }
}
