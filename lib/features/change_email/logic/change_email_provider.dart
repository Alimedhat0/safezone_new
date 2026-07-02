import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_zone/l10n/generated/app_localizations.dart';

class ChangeEmailProvider extends ChangeNotifier {
  final newEmailController = TextEditingController();
  final confirmEmailController = TextEditingController();
  final oldEmailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  Future<void> updateEmail(BuildContext context, String password) async {
    final l10n = AppLocalizations.of(context)!;
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

      if (newEmail.isEmpty || confirmEmail.isEmpty) {
        throw Exception(l10n.fill_all_fields);
      }

      if (newEmail != confirmEmail) {
        throw Exception(l10n.please_enter_a_new_email_address);
      }

      final credential = EmailAuthProvider.credential(
        email: currentEmail,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      await user.verifyBeforeUpdateEmail(newEmail);
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'email': newEmail},
      );
      Fluttertoast.showToast(msg: l10n.verification_email_sent(newEmail));

      newEmailController.clear();
      confirmEmailController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? l10n.firebase_error);
      throw Exception(e.message);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
