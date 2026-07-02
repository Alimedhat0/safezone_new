import 'package:flutter/material.dart';
import 'package:safe_zone/features/about/models/about_model.dart';
import 'package:safe_zone/l10n/generated/app_localizations.dart';

class AboutProvider extends ChangeNotifier {
  List<AboutModel> localizedAboutList(AppLocalizations l10n) => [
    AboutModel(icon: Icons.error, title: l10n.about_sos_alert),
    AboutModel(
      icon: Icons.location_on_outlined,
      title: l10n.about_share_live_location,
    ),
    AboutModel(
      icon: Icons.flash_on,
      title: l10n.about_multiple_triggers,
    ),
    AboutModel(
      icon: Icons.notifications_none_outlined,
      title: l10n.about_notify_emergency_services,
    ),
  ];
  List<Color> colors = [
    Colors.pinkAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.redAccent,
  ];
}
