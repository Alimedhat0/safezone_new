import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';
import 'package:safe_zone/features/language/widgets/language_tile.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.tr;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.languages), centerTitle: true),
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              LanguageTile(
                value: 'en',
                groupValue: provider.locale.languageCode,
                title: l10n.english,
                subtitle: l10n.english_native,
                onTap: () {
                  provider.changLang('en');
                },
              ),
              LanguageTile(
                value: 'ar',
                groupValue: provider.locale.languageCode,
                title: l10n.arabic,
                subtitle: l10n.arabic_native,
                onTap: () {
                  provider.changLang('ar');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
