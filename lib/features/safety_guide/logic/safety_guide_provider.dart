import 'package:flutter/material.dart';
import 'package:safe_zone/features/safety_guide/models/safety_guide_model.dart';
import 'package:safe_zone/l10n/generated/app_localizations.dart';

class SafetyGuideProvider extends ChangeNotifier {
  List<SafetyGuideModel> localizedSafetyList(AppLocalizations l10n) => [
    SafetyGuideModel(icon: Icons.shield, title: l10n.walk_in_instincts),
    SafetyGuideModel(icon: Icons.home_outlined, title: l10n.keep_your_safe_spot),
    SafetyGuideModel(
      icon: Icons.flash_on,
      title: l10n.carry_flashlight_at_night,
    ),
    SafetyGuideModel(
      icon: Icons.grass,
      title: l10n.share_your_plans_with_family,
    ),
    SafetyGuideModel(
      icon: Icons.emoji_transportation,
      title: l10n.use_public_transportation,
    ),
    SafetyGuideModel(
      icon: Icons.battery_charging_full_outlined,
      title: l10n.keep_your_phone_charged,
    ),
    SafetyGuideModel(
      icon: Icons.shield_moon_outlined,
      title: l10n.avoid_physical_confrontations,
    ),
    SafetyGuideModel(
      icon: Icons.local_drink,
      title: l10n.say_no_excessive_drinks,
    ),
  ];
}
