import 'package:flutter/material.dart';
import 'package:safe_zone/features/emergency_contacts/models/emergency_contact_model.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyProvider extends ChangeNotifier {
  List<EmergencyContactModel> emergencyData = [
    EmergencyContactModel(
      image: 'assests/svgs/icon_police4.svg',
      phone: '122',
      type: 'Police',
    ),
    EmergencyContactModel(
      image: 'assests/svgs/fire_icon.svg',
      phone: '180',
      type: 'Fire',
    ),
    EmergencyContactModel(
      image: 'assests/svgs/sharpicons_ambulance_icon.svg',
      phone: '123',
      type: 'Ambulance',
    ),
    EmergencyContactModel(
      image: 'assests/svgs/number4_icon.svg',
      phone: '15115',
      type: 'Domestic Violance Hotline',
    ),
    EmergencyContactModel(
      image: 'assests/svgs/ihealth_icon.svg',
      phone: '107',
      type: 'Mental Health Support Hotline',
    ),
    EmergencyContactModel(
      image: 'assests/svgs/call_fill.svg',
      phone: '128',
      type: 'Read Highway Emergency Services',
    ),
  ];

  Future<void> launchPhone(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    try {
      await launchUrl(uri);
    } catch (e) {
      print('Error with Launcher: $e');
    }
  }
}
