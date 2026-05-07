import 'package:flutter/material.dart';
import 'package:safe_zone/features/onboarding/models/onboarding_model.dart';

class OnboardingProvider extends ChangeNotifier {
  List<OnboardingModel> screens = [
    OnboardingModel(
      image: "assests/images/onboarding1.png",
      // title: "Stay Safe any where",
      subtitle: "Stay Safe any where\n Your safety is our priority",
    ),
    OnboardingModel(
      image: "assests/images/onboarding2.png",
      title: "Send an alert",
      subtitle: "Send an alert to your\n family if you need help.",
    ),
    OnboardingModel(
      image: "assests/images/onboarding3.png",
      title: "Share Location",
      subtitle: "We will share your location\n with trusted contacts.",
    ),
  ];
}
