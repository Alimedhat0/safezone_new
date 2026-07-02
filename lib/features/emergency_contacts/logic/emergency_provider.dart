import 'package:flutter/material.dart';
import 'package:safe_zone/features/emergency_contacts/models/emergency_contact_model.dart';
import 'package:safe_zone/l10n/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyProvider extends ChangeNotifier {
  List<EmergencyContactModel> localizedEmergencyData(AppLocalizations l10n) => [
    EmergencyContactModel(
      image: 'assests/svgs/icon_police4.svg',
      phone: '122',
      type: l10n.police,
    ),
    EmergencyContactModel(
      image: 'assests/svgs/fire_icon.svg',
      phone: '180',
      type: l10n.fire,
    ),
    EmergencyContactModel(
      image: 'assests/svgs/sharpicons_ambulance_icon.svg',
      phone: '123',
      type: l10n.ambulance,
    ),
    EmergencyContactModel(
      image: 'assests/svgs/number4_icon.svg',
      phone: '15115',
      type: l10n.domestic_violence_hotline,
    ),
    EmergencyContactModel(
      image: 'assests/svgs/ihealth_icon.svg',
      phone: '107',
      type: l10n.mental_health_support_hotline,
    ),
    EmergencyContactModel(
      image: 'assests/svgs/call_fill.svg',
      phone: '128',
      type: l10n.road_highway_emergency_services,
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
