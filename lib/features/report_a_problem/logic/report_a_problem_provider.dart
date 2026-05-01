import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_zone/features/report_a_problem/model/report_a_problem_model.dart';

class ReportAProblemProvider extends ChangeNotifier {
  String? selectedCategory;
  final TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;

  final List<String> categories = [
    "App not working",
    "Location issue",
    "Trigger not responding",
    "Notification problem",
    "Other",
  ];

  void selectCategory(String value) {
    selectedCategory = value;
    notifyListeners();
  }

  Future<void> submitReport() async {
    if (selectedCategory == null || descriptionController.text.isEmpty) {
      throw Exception("Fill all fields");
    }

    isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;

      final report = ReportAProblemModel(
        category: selectedCategory!,
        description: descriptionController.text,
        userId: user?.uid ?? "guest",
        createdAt: DateTime.now().toIso8601String(),
      );

      await FirebaseFirestore.instance
          .collection('reportproblem')
          .add(report.toMap());

      selectedCategory = null;
      descriptionController.clear();
    } catch (e) {
      rethrow;
    }

    isLoading = false;
    notifyListeners();
  }
}
