import 'package:flutter/material.dart';
import 'package:safe_zone/features/about/models/about_model.dart';

class AboutProvider extends ChangeNotifier {
  List<AboutModel> aboutList = [
    AboutModel(icon: Icons.error, title: 'Send SOS alert instantly'),
    AboutModel(
      icon: Icons.location_on_outlined,
      title: 'Share live location with trusted contacts',
    ),
    AboutModel(
      icon: Icons.flash_on,
      title: 'Use multiple emergency triggers (press, shake, voice keyword)',
    ),
    AboutModel(
      icon: Icons.notifications_none_outlined,
      title: 'Automatically notify emergency services',
    ),
  ];
  List<Color> colors = [
    Colors.pinkAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.redAccent,
  ];
}
