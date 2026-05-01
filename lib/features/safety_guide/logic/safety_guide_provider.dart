import 'package:flutter/material.dart';
import 'package:safe_zone/features/safety_guide/models/safety_guide_model.dart';

class SafetyGuideProvider extends ChangeNotifier {
  List<SafetyGuideModel> safetyList = [
    SafetyGuideModel(icon: Icons.shield, title: 'Walk in instnicts'),
    SafetyGuideModel(icon: Icons.home_outlined, title: 'Keep your safe spot'),
    SafetyGuideModel(
      icon: Icons.flash_on,
      title: 'Carry a flashlight at night',
    ),
    SafetyGuideModel(icon: Icons.grass, title: 'Share your plans with family'),
    SafetyGuideModel(
      icon: Icons.emoji_transportation,
      title: 'Use a public transportation',
    ),
    SafetyGuideModel(
      icon: Icons.battery_charging_full_outlined,
      title: 'Keep your phone charged',
    ),
    SafetyGuideModel(
      icon: Icons.shield_moon_outlined,
      title: 'Avoid physical confrontations',
    ),
    SafetyGuideModel(icon: Icons.local_drink, title: 'Say no excessive drinks'),
  ];
}
