import 'package:flutter/material.dart';
import 'package:safe_zone/features/faq/models/faq_model.dart';

class FaqProvider extends ChangeNotifier {
  List<FaqModel> faqList = [
    FaqModel(
      question: 'How does the emergency trigger work?',
      answer:
          'The emergency trigger can be activated in multiple ways: pressing the power button 3 times, shaking your phone vigorously, or long-pressing the screen for 3 seconds. Once triggered, your emergencycontacts will benotified immediately with your location.',
    ),
    FaqModel(
      question: 'Is my location shared all the time?',
      answer:
          'No, your location is only shared when you activate an emergency alert or if you choose to share your live location with trusted contacts. SafeZone respects your privacy and only accesses location when necessary.',
    ),
    FaqModel(
      question: 'How do i change my emergency contacts',
      answer:
          'Go to Settings, then tap on "Emergency Contacts". You can add, remove, or edit contacts from there. We recommend having at least 3 trusted contacts for emergency situations.',
    ),
    FaqModel(
      question: 'What permissions does SafeZone need?',
      answer:
          'SafeZone requires location access to send accurate emergency alerts, microphone access for voice activation (optional), and notification permissions to alert you. All permissions are used solely for your safety.',
    ),
    FaqModel(
      question: 'Can i use SafeZone without internet?',
      answer:
          'Some features like SMS alerts can work offline, but most features including location sharing and real-time updates require an internet connection for best performance.',
    ),
    FaqModel(
      question: 'Is my personal information secure?',
      answer:
          'Yes, SafeZone uses end-to-end encryption for all communications. Your personal data is stored securely and is never shared with third parties. We follow industry-standard security practices to protect your information.',
    ),
    FaqModel(
      question: 'How much battery does SafeZone use?',
      answer:
          'SafeZone is optimized for minimal battery usage. Background location tracking uses GPS efficiently, and the app only becomes active when you trigger an emergency or actively use features.',
    ),
  ];

  String search = '';
  List<FaqModel> get filteredFaq {
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
