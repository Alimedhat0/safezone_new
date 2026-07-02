import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/features/app_theme/widgets/theme_tile.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';

class AppThemeScreen extends StatelessWidget {
  const AppThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.tr;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.app_theme), centerTitle: true),
      body: Column(
        children: [
          Consumer<HomeProvider>(
            builder: (context, provider, _) {
              return Column(
                children: [
                  ThemeTile(
                    value: ThemeMode.light,
                    groupValue: provider.themeMode,
                    onChanged: (value) {
                      provider.changeTheme(value);
                    },
                    title: l10n.light_mode,
                    secondry: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.light_mode, color: Colors.amber),
                    ),
                  ),
                  ThemeTile(
                    value: ThemeMode.dark,
                    groupValue: provider.themeMode,
                    onChanged: (value) {
                      provider.changeTheme(value);
                    },
                    title: l10n.dark_mode,
                    secondry: CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Icon(Icons.dark_mode, color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
