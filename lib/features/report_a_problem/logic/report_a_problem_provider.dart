import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_zone/features/report_a_problem/model/report_a_problem_model.dart';
import 'package:safe_zone/l10n/generated/app_localizations.dart';

class ReportAProblemProvider extends ChangeNotifier {
  String? selectedCategory;
  final TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;

  List<String> localizedCategories(AppLocalizations l10n) => [
    l10n.category_app_not_working,
    l10n.category_location_issue,
    l10n.category_trigger_not_responding,
    l10n.category_notification_problem,
    l10n.category_other,
  ];

  void selectCategory(String value) {
    selectedCategory = value;
    notifyListeners();
  }

  Future<void> submitReport(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    if (selectedCategory == null || descriptionController.text.isEmpty) {
      throw Exception(l10n.fill_all_fields);
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
