import 'package:flutter/material.dart';

class EmegencyTriggerProvider extends ChangeNotifier {
  bool shakePhone = false;
  bool powerButton = true;
  void toggleShake(bool value) {
    shakePhone = value;
    notifyListeners();
  }

  void togglepower(bool value) {
    powerButton = value;
    notifyListeners();
  }

  Map<String, bool> settings = {'shake': false, 'power': true};
  void updateSetting(String key, bool value) {
    settings[key] = value;
    notifyListeners();
  }
}
