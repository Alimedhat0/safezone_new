import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';
import 'package:safe_zone/features/register/model/register_model.dart';
import 'package:safe_zone/l10n/generated/app_localizations.dart';

class PersonalInfoProvider extends ChangeNotifier {
  String selectedCode = "+20";
  String? gender;
  List<String> countryCodes = ["+20", "+1", "+44", "+91"];
  List<String> genderList(AppLocalizations l10n) => [
    l10n.gender_male,
    l10n.gender_female,
  ];
  bool isLoading = false;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final birthController = TextEditingController();
  DateTime? pickedDate;

  final formKey = GlobalKey<FormState>();
  Future<void> editProfile(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
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
      Fluttertoast.showToast(msg: l10n.profile_updated_successfully);
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? l10n.unknown_error);
    } finally {
      isLoading = false;
      notifyListeners();
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
