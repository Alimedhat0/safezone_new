import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:safe_zone/features/home/data/gird_services_data.dart';
import 'package:safe_zone/features/notification/logic/notification_provider.dart';
import 'package:safe_zone/main.dart';

class LoginProvider extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  bool isvisible = true;

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    isLoading = true;
    notifyListeners();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Fluttertoast.showToast(msg: 'Login Successfully');
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
    } catch (e) {
      print('Erorr With login :$e');
      Fluttertoast.showToast(msg: 'An error occurred');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future saveUser(User user) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await doc.get();
    if (!snapshot.exists) {
      await doc.set({
        'name': user.displayName,
        'email': user.email,
        'photo': user.photoURL,
        'uid': user.uid,
        'createdAt': DateTime.now(),
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
