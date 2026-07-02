import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_zone/features/home/data/gird_services_data.dart';
import 'package:safe_zone/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmegencyTriggerProvider extends ChangeNotifier {
  static const Map<String, bool> _defaultSettings = {
    'shake': false,
    'power': true,
  };
  static const String _prefsPrefix = 'emergency_trigger_';

  final GirdServicesData _sosService = GirdServicesData();

  bool isTestingTrigger = false;
  Map<String, bool> settings = Map<String, bool>.from(_defaultSettings);

  bool get isShakeEnabled => settings['shake'] ?? false;
  bool get isPowerEnabled => settings['power'] ?? true;
  bool get hasEnabledTrigger => isShakeEnabled || isPowerEnabled;

  String _prefKey(String key) => '$_prefsPrefix$key';

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    for (final entry in _defaultSettings.entries) {
      settings[entry.key] = prefs.getBool(_prefKey(entry.key)) ?? entry.value;
    }

    notifyListeners();
  }

  Future<void> updateSetting(String key, bool value) async {
    if (!settings.containsKey(key)) return;

    settings[key] = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey(key), value);
  }

  Future<bool> runShakeTrigger(AppLocalizations l10n) async {
    if (!isShakeEnabled) {
      Fluttertoast.showToast(msg: l10n.shake_trigger_disabled);
      return false;
    }

    return _runSosTrigger(l10n.shake_the_phone, l10n);
  }

  Future<bool> runPowerTrigger(AppLocalizations l10n) async {
    if (!isPowerEnabled) {
      Fluttertoast.showToast(msg: l10n.power_button_trigger_disabled);
      return false;
    }

    return _runSosTrigger(l10n.press_power_button_three_times, l10n);
  }

  Future<bool> _runSosTrigger(String source, AppLocalizations l10n) async {
    if (isTestingTrigger) return false;

    isTestingTrigger = true;
    notifyListeners();

    try {
      await _sosService.triggerVoiceSos();
      Fluttertoast.showToast(msg: l10n.trigger_executed(source));
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: l10n.failed_to_execute_trigger(source));
      return false;
    } finally {
      isTestingTrigger = false;
      notifyListeners();
    }
  }

  Future<void> testDefaultTrigger(AppLocalizations l10n) async {
    if (!hasEnabledTrigger) {
      Fluttertoast.showToast(msg: l10n.enable_at_least_one_trigger_first);
      return;
    }

    if (isShakeEnabled) {
      await runShakeTrigger(l10n);
      return;
    }

    await runPowerTrigger(l10n);
  }
}
