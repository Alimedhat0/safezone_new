import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_zone/l10n/generated/app_localizations.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> resetPassword(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      isLoading = true;
      notifyListeners();

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      Fluttertoast.showToast(msg: l10n.password_reset_link_sent);

      emailController.clear();
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? l10n.error_occurred);
    }

    isLoading = false;
    notifyListeners();
  }
}
