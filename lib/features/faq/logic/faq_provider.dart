import 'package:flutter/material.dart';
import 'package:safe_zone/features/faq/models/faq_model.dart';
import 'package:safe_zone/l10n/generated/app_localizations.dart';

class FaqProvider extends ChangeNotifier {
  List<FaqModel> localizedFaqList(AppLocalizations l10n) => [
    FaqModel(
      question: l10n.faq_question_emergency_trigger,
      answer: l10n.faq_answer_emergency_trigger,
    ),
    FaqModel(
      question: l10n.faq_question_location_shared,
      answer: l10n.faq_answer_location_shared,
    ),
    FaqModel(
      question: l10n.faq_question_change_contacts,
      answer: l10n.faq_answer_change_contacts,
    ),
    FaqModel(
      question: l10n.faq_question_permissions,
      answer: l10n.faq_answer_permissions,
    ),
    FaqModel(
      question: l10n.faq_question_without_internet,
      answer: l10n.faq_answer_without_internet,
    ),
    FaqModel(
      question: l10n.faq_question_information_secure,
      answer: l10n.faq_answer_information_secure,
    ),
    FaqModel(
      question: l10n.faq_question_battery_usage,
      answer: l10n.faq_answer_battery_usage,
    ),
  ];

  String search = '';
  List<FaqModel> filteredFaq(AppLocalizations l10n) {
    final faqList = localizedFaqList(l10n);
    if (search.isEmpty) return faqList;

    return faqList
        .where((e) => e.question.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

  void searchInFAQ(String searchValue) {
    search = searchValue;
    notifyListeners();
  }
}
