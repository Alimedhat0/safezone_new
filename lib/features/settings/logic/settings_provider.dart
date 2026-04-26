import 'package:flutter/material.dart';
import 'package:safe_zone/features/change_email/ui/change_email_screen.dart';
import 'package:safe_zone/features/change_password/ui/change_password_screen.dart';
import 'package:safe_zone/features/emergency_trigger/ui/emergency_trigger_screen.dart';
import 'package:safe_zone/features/personal_info/ui/personal_info_screen.dart';
import 'package:safe_zone/features/settings/models/cardscontent.dart';
import 'package:safe_zone/features/trusted_contacts/ui/trusted_contact_screen.dart';

class SettingsProvider extends ChangeNotifier {
  // bool liveOn = true;
  bool timeron = false;
  bool notificationOn = true;
  bool alertSoundOn = true;
  bool alertVibrationOn = true;
  bool locationAccOn = true;
  bool cameraAccOn = false;
  bool micAccOn = true;

  Map<String, bool> settings = {
    'liveOn': true,
    'timeron': false,
    'notificationOn': true,
    'alertSoundOn': true,
    'alertVibrationOn': true,
    'locationAccOn': true,
    'cameraAccOn': false,
    'micAccOn': true,
  };

  void updateSetting(String key, bool value) {
    settings[key] = value;
    notifyListeners();
  }

  List<Cardscontent> cardscontent = [
    Cardscontent(
      preicon: Icons.person_2_outlined,
      title: 'Personal Information',
      screen: PersonalInfoScreen(),
    ),
    Cardscontent(
      preicon: Icons.email_outlined,
      title: 'Change Email',
      screen: ChangeEmailScreen(),
    ),
    Cardscontent(
      preicon: Icons.lock_outline,
      title: 'Change Password',
      screen: ChangePasswordScreen(),
    ),
    Cardscontent(
      preicon: Icons.people_alt_outlined,
      title: 'Trusted Contacts',
      screen: TrustedContactScreen(),
    ),
    Cardscontent(
      preicon: Icons.flash_on,
      title: 'Emergency Triggers',
      screen: EmergencyTriggerScreen(),
    ),
    Cardscontent(
      preicon: Icons.language,
      title: 'Languages',
      screen: TrustedContactScreen(),
    ),
    Cardscontent(
      preicon: Icons.color_lens_outlined,
      title: 'App Theme',
      screen: TrustedContactScreen(),
    ),
    Cardscontent(
      preicon: Icons.help_outline,
      title: 'FAQ',
      screen: TrustedContactScreen(),
    ),
    Cardscontent(
      preicon: Icons.error_outline,
      title: 'Report a Problem',
      screen: TrustedContactScreen(),
    ),
    Cardscontent(
      preicon: Icons.error_outline,
      title: 'About',
      screen: TrustedContactScreen(),
    ),
  ];
}
