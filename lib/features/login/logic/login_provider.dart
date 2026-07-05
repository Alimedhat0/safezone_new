import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:safe_zone/features/home/data/gird_services_data.dart';
import 'package:safe_zone/features/notification/logic/notification_provider.dart';
import 'package:safe_zone/l10n/generated/app_localizations.dart';
import 'package:safe_zone/main.dart';

class LoginProvider extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  bool isvisible = true;

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    isLoading = true;
    notifyListeners();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final girdServices = GirdServicesData();
        await girdServices.saveUserUid(user.uid);
        await NotificationProvider().saveCurrentUserFcmToken();
      }

      Fluttertoast.showToast(msg: l10n.login_successfully);
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainApp()),
      );
    } catch (e) {
      debugPrint('Error with login: $e');
      Fluttertoast.showToast(msg: l10n.an_error_occurred);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    isLoading = true;
    notifyListeners();

    try {
      final googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user == null) {
        Fluttertoast.showToast(msg: l10n.an_error_occurred);
        return;
      }

      await saveUser(user);
      final girdServices = GirdServicesData();
      await girdServices.saveUserUid(user.uid);
      await NotificationProvider().saveCurrentUserFcmToken();

      Fluttertoast.showToast(msg: l10n.login_successfully);
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainApp()),
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? l10n.an_error_occurred);
    } catch (e) {
      debugPrint('Error with Google sign-in: $e');
      Fluttertoast.showToast(msg: l10n.an_error_occurred);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future saveUser(User user) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await doc.get();
    if (!snapshot.exists) {
      await doc.set({
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'phone': user.phoneNumber ?? '',
        'uid': user.uid,
        'isTrusted': false,
      });
    }
  }

  Future signOutWithGoogle() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  void togglePasswordVisibility() {
    isvisible = !isvisible;
    notifyListeners();
  }
}
