import 'package:flutter/material.dart';
import 'package:safe_zone/l10n/generated/app_localizations.dart';

class Cardscontent {
  final IconData preicon;
  final String Function(AppLocalizations l10n) title;
  final Widget screen;

  Cardscontent({
    required this.preicon,
    required this.title,
    required this.screen,
  });
}
