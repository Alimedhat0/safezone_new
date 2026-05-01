import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';
import 'package:safe_zone/features/language/widgets/language_tile.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Languages'), centerTitle: true),
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              // Card(
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(16),
              //   ),
              //   elevation: 6,
              //   child: RadioListTile(
              //     value: 'en',
              //     groupValue: provider.locale.languageCode,
              //     onChanged: (value) {
              //       provider.changLang(value!);
              //     },
              //     title: Text('English', style: TextStyle(color: Colors.blue)),
              //     subtitle: Text('English'),
              //   ),
              // ),
              // Card(
              //   elevation: 6,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(16),
              //   ),
              //   child: RadioListTile(
              //     value: 'ar',
              //     groupValue: provider.locale.languageCode,
              //     onChanged: (value) {
              //       provider.changLang(value!);
              //     },
              //     title: Text('Arabic', style: TextStyle(color: Colors.blue)),
              //     subtitle: Text('العربية'),
              //   ),
              // ),
              LanguageTile(
                value: 'en',
                groupValue: provider.locale.languageCode,
                title: 'English',
                subtitle: 'English',
                onTap: () {
                  provider.changLang('en');
                },
              ),
              LanguageTile(
                value: 'ar',
                groupValue: provider.locale.languageCode,
                title: 'Arabic',
                subtitle: 'العربية',
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
