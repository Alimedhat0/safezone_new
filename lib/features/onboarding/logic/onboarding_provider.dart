import 'package:flutter/material.dart';
import 'package:safe_zone/features/onboarding/models/onboarding_model.dart';
import 'package:safe_zone/l10n/generated/app_localizations.dart';

class OnboardingProvider extends ChangeNotifier {
  List<OnboardingModel> localizedScreens(AppLocalizations l10n) => [
    OnboardingModel(
      image: "assests/images/onboarding1.png",
      subtitle: l10n.stay_safe_anywhere,
    ),
    OnboardingModel(
      image: "assests/images/onboarding2.png",
      title: l10n.send_alert,
      subtitle: l10n.send_alert_onboarding,
    ),
    OnboardingModel(
      image: "assests/images/onboarding3.png",
      title: l10n.share_location_title,
      subtitle: l10n.share_location_onboarding,
    ),
  ];
}
