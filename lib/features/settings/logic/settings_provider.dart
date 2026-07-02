import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_zone/core/services/background_services.dart';
import 'package:safe_zone/core/services/location_permission_service.dart';
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
import 'package:safe_zone/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier with WidgetsBindingObserver {
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

  static const Set<String> _permissionSettingKeys = {
    'notificationOn',
    'locationAccOn',
    'cameraAccOn',
    'micAccOn',
  };

  static const String _settingsPrefix = 'settings_';
  bool isDeletingAccount = false;

  Map<String, bool> settings = Map<String, bool>.from(_defaultSettings);

  SettingsProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  String _prefKey(String settingKey) => '$_settingsPrefix$settingKey';

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    for (final entry in _defaultSettings.entries) {
      settings[entry.key] = prefs.getBool(_prefKey(entry.key)) ?? entry.value;
    }

    await _syncPermissionSettings(save: true);
    notifyListeners();
  }

  Future<void> updateSetting(
    String key,
    bool value, {
    required AppLocalizations l10n,
  }) async {
    if (!settings.containsKey(key)) return;

    if (_permissionSettingKeys.contains(key)) {
      await _updatePermissionSetting(key, value, l10n);
      return;
    }

    settings[key] = value;
    notifyListeners();
    await _saveSetting(key, value);
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey(key), value);
  }

  Future<void> refreshPermissionSettings() async {
    await _syncPermissionSettings(save: true);
    notifyListeners();
  }

  Future<void> _syncPermissionSettings({required bool save}) async {
    for (final key in _permissionSettingKeys) {
      final isGranted = await _isPermissionGranted(key);
      settings[key] = isGranted;

      if (save) {
        await _saveSetting(key, isGranted);
      }
    }
  }

  Future<void> _updatePermissionSetting(
    String key,
    bool shouldEnable,
    AppLocalizations l10n,
  ) async {
    final isGranted =
        shouldEnable
            ? await _requestPermission(key, l10n)
            : await _openSettingsToDisablePermission(key, l10n);

    settings[key] = isGranted;
    notifyListeners();
    await _saveSetting(key, isGranted);
  }

  Future<bool> _isPermissionGranted(String key) async {
    if (key == 'locationAccOn') {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) return false;

      final permission = await Geolocator.checkPermission();
      return _isLocationPermissionGranted(permission);
    }

    final status = await _permissionForKey(key).status;
    return status.isGranted;
  }

  Future<bool> _requestPermission(String key, AppLocalizations l10n) async {
    if (key == 'locationAccOn') {
      return _requestLocationPermission(l10n);
    }

    final status = await _permissionForKey(key).request();

    if (!status.isGranted) {
      await _handleDeniedPermission(key, status, l10n);
    }

    return status.isGranted;
  }

  Future<bool> _requestLocationPermission(AppLocalizations l10n) async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      Fluttertoast.showToast(msg: l10n.please_enable_location_services);
      await Geolocator.openLocationSettings();
      return false;
    }

    final isGranted = await LocationPermissionService.ensurePermission();
    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
        msg: l10n.location_permission_disabled_from_settings,
      );
    } else if (!isGranted) {
      Fluttertoast.showToast(msg: l10n.location_permission_denied);
    }

    return isGranted;
  }

  Future<bool> _openSettingsToDisablePermission(
    String key,
    AppLocalizations l10n,
  ) async {
    final label = _permissionLabel(key, l10n);
    Fluttertoast.showToast(
      msg: l10n.disable_permission_from_app_settings(label),
    );

    if (key == 'locationAccOn') {
      await Geolocator.openAppSettings();
    } else {
      await openAppSettings();
    }

    return _isPermissionGranted(key);
  }

  Future<void> _handleDeniedPermission(
    String key,
    PermissionStatus status,
    AppLocalizations l10n,
  ) async {
    final label = _permissionLabel(key, l10n);

    if (status.isPermanentlyDenied || status.isRestricted) {
      Fluttertoast.showToast(
        msg: l10n.permission_disabled_from_app_settings(label),
      );
      await openAppSettings();
      return;
    }

    Fluttertoast.showToast(msg: l10n.permission_denied(label));
  }

  Permission _permissionForKey(String key) {
    switch (key) {
      case 'notificationOn':
        return Permission.notification;
      case 'cameraAccOn':
        return Permission.camera;
      case 'micAccOn':
        return Permission.microphone;
      default:
        throw UnsupportedError('Unknown permission setting: $key');
    }
  }

  bool _isLocationPermissionGranted(LocationPermission permission) {
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  String _permissionLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'notificationOn':
        return l10n.permission_notification;
      case 'locationAccOn':
        return l10n.permission_location;
      case 'cameraAccOn':
        return l10n.permission_camera;
      case 'micAccOn':
        return l10n.permission_microphone;
      default:
        return 'App';
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(refreshPermissionSettings());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Cardscontent> cardscontent = [
    Cardscontent(
      preicon: Icons.person_2_outlined,
      title: (l10n) => l10n.personal_information,
      screen: PersonalInfoScreen(),
    ),
    Cardscontent(
      preicon: Icons.email_outlined,
      title: (l10n) => l10n.change_email,
      screen: ChangeEmailScreen(),
    ),
    Cardscontent(
      preicon: Icons.lock_outline,
      title: (l10n) => l10n.change_password,
      screen: ChangePasswordScreen(),
    ),
    Cardscontent(
      preicon: Icons.people_alt_outlined,
      title: (l10n) => l10n.trusted_contacts,
      screen: TrustedContactScreen(),
    ),
    Cardscontent(
      preicon: Icons.flash_on,
      title: (l10n) => l10n.emergency_triggers,
      screen: EmergencyTriggerScreen(),
    ),
    Cardscontent(
      preicon: Icons.language,
      title: (l10n) => l10n.languages,
      screen: LanguageScreen(),
    ),
    Cardscontent(
      preicon: Icons.color_lens_outlined,
      title: (l10n) => l10n.app_theme,
      screen: AppThemeScreen(),
    ),
    Cardscontent(
      preicon: Icons.help_outline,
      title: (l10n) => l10n.faq,
      screen: FaqScreen(),
    ),
    Cardscontent(
      preicon: Icons.error_outline,
      title: (l10n) => l10n.report_a_problem,
      screen: ReportAProblemScreen(),
    ),
    Cardscontent(
      preicon: Icons.error_outline,
      title: (l10n) => l10n.about,
      screen: AboutScreen(),
    ),
  ];
  Future<void> clearUid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("uid");
  }

  Future<void> deleteCurrentAccount(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    if (isDeletingAccount) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Fluttertoast.showToast(msg: l10n.no_active_account_found);
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
      Fluttertoast.showToast(msg: l10n.account_deleted_successfully);

      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        Fluttertoast.showToast(msg: l10n.login_again_before_deleting_account);
      } else {
        Fluttertoast.showToast(msg: e.message ?? l10n.failed_to_delete_account);
      }
    } catch (_) {
      Fluttertoast.showToast(msg: l10n.failed_to_delete_account);
    } finally {
      isDeletingAccount = false;
      notifyListeners();
    }
  }
}
