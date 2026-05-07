import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_zone/core/services/background_services.dart';
import 'package:safe_zone/features/about/ui/about_screen.dart';
import 'package:safe_zone/features/app_theme/ui/app_theme_screen.dart';
import 'package:safe_zone/features/change_email/ui/change_email_screen.dart';
import 'package:safe_zone/features/change_password/ui/change_password_screen.dart';
import 'package:safe_zone/features/emergency_trigger/ui/emergency_trigger_screen.dart';
import 'package:safe_zone/features/faq/ui/faq_screen.dart';
import 'package:safe_zone/features/language/ui/language_screen.dart';
import 'package:safe_zone/features/login/ui/login_screen.dart';
import 'package:safe_zone/features/personal_info/ui/personal_info_screen.dart';
import 'package:safe_zone/features/report_a_problem/ui/report_a_problem_screen.dart';
import 'package:safe_zone/features/settings/models/cardscontent.dart';
import 'package:safe_zone/features/trusted_contacts/ui/trusted_contact_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const Map<String, bool> _defaultSettings = {
    'liveOn': true,
    'timeron': false,
    'notificationOn': true,
    'alertSoundOn': true,
    'alertVibrationOn': true,
    'locationAccOn': true,
    'cameraAccOn': false,
    'micAccOn': true,
  };

  static const String _settingsPrefix = 'settings_';
  bool isDeletingAccount = false;

  Map<String, bool> settings = Map<String, bool>.from(_defaultSettings);

  String _prefKey(String settingKey) => '$_settingsPrefix$settingKey';

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    for (final entry in _defaultSettings.entries) {
      settings[entry.key] = prefs.getBool(_prefKey(entry.key)) ?? entry.value;
    }

    notifyListeners();
  }

  void updateSetting(String key, bool value) {
    if (!settings.containsKey(key)) return;

    settings[key] = value;
    notifyListeners();
    _saveSetting(key, value);
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey(key), value);
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
      screen: LanguageScreen(),
    ),
    Cardscontent(
      preicon: Icons.color_lens_outlined,
      title: 'App Theme',
      screen: AppThemeScreen(),
    ),
    Cardscontent(
      preicon: Icons.help_outline,
      title: 'FAQ',
      screen: FaqScreen(),
    ),
    Cardscontent(
      preicon: Icons.error_outline,
      title: 'Report a Problem',
      screen: ReportAProblemScreen(),
    ),
    Cardscontent(
      preicon: Icons.error_outline,
      title: 'About',
      screen: AboutScreen(),
    ),
  ];
  Future<void> clearUid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("uid");
  }

  Future<void> deleteCurrentAccount(BuildContext context) async {
    if (isDeletingAccount) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Fluttertoast.showToast(msg: 'No active account found');
      return;
    }

    isDeletingAccount = true;
    notifyListeners();

    try {
      await stopVoiceService();
      await user.delete();
      try {
        await FirebaseAuth.instance.signOut();
      } catch (_) {}
      await clearUid();
      await clearVoiceKeywords();
      Fluttertoast.showToast(msg: 'Account deleted successfully');

      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        Fluttertoast.showToast(
          msg: 'For security, please login again before deleting account',
        );
      } else {
        Fluttertoast.showToast(msg: e.message ?? 'Failed to delete account');
      }
    } catch (_) {
      Fluttertoast.showToast(msg: 'Failed to delete account');
    } finally {
      isDeletingAccount = false;
      notifyListeners();
    }
  }
}
