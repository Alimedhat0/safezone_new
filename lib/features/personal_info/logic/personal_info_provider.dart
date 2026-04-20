import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';
import 'package:safe_zone/features/register/model/register_model.dart';

class PersonalInfoProvider extends ChangeNotifier {
  String selectedCode = "+20";
  String? gender;
  List<String> countryCodes = ["+20", "+1", "+44", "+91"];
  List<String> genderList = ['Male', 'Femail'];
  bool isLoading = false;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final birthController = TextEditingController();
  DateTime? pickedDate;

  final formKey = GlobalKey<FormState>();
  Future<void> editProfile(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    isLoading = true;
    notifyListeners();
    try {
      final user = FirebaseAuth.instance.currentUser!;
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': nameController.text,
        'phone': phoneController.text,
      });
      await context.read<HomeProvider>().getUser();
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: 'Profile updated successfully');
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? 'Unknown error');
    }
  }

  void init(RegisterModel? model) {
    if (model == null) return;

    nameController.text = model.name;
    phoneController.text = model.phone;
    emailController.text = model.email;

    notifyListeners();
  }
}
