import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_zone/l10n/generated/app_localizations.dart';

class ChangePasswordProvider extends ChangeNotifier {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Future<void> updatePassword(
    BuildContext context,
    String newPassword,
    String currentPassword,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    isLoading = true;
    notifyListeners();
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }

      final email = user.email!;

      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);
      Fluttertoast.showToast(msg: l10n.password_updated_successfully);

      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      print("Password updated successfully");
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
