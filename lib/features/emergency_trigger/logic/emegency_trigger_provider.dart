import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_zone/features/home/data/gird_services_data.dart';
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

  Future<bool> runShakeTrigger() async {
    if (!isShakeEnabled) {
      Fluttertoast.showToast(msg: 'Shake trigger is disabled');
      return false;
    }

    return _runSosTrigger('Shake');
  }

  Future<bool> runPowerTrigger() async {
    if (!isPowerEnabled) {
      Fluttertoast.showToast(msg: 'Power button trigger is disabled');
      return false;
    }

    return _runSosTrigger('Power button');
  }

  Future<bool> _runSosTrigger(String source) async {
    if (isTestingTrigger) return false;

    isTestingTrigger = true;
    notifyListeners();

    try {
      await _sosService.triggerVoiceSos();
      Fluttertoast.showToast(msg: '$source trigger executed');
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to execute $source trigger');
      return false;
    } finally {
      isTestingTrigger = false;
      notifyListeners();
    }
  }

  Future<void> testDefaultTrigger() async {
    if (!hasEnabledTrigger) {
      Fluttertoast.showToast(msg: 'Enable at least one trigger first');
      return;
    }

    if (isShakeEnabled) {
      await runShakeTrigger();
      return;
    }

    await runPowerTrigger();
  }
}
