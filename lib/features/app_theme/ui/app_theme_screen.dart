import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/features/app_theme/widgets/theme_tile.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';

class AppThemeScreen extends StatelessWidget {
  const AppThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('App Theme'), centerTitle: true),
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
                      provider.toggleTheme(false);
                    },
                    title: 'Light Mood',
                    secondry: CircleAvatar(child: Icon(Icons.light_mode)),
                  ),
                  ThemeTile(
                    value: ThemeMode.dark,
                    groupValue: provider.themeMode,
                    onChanged: (value) {
                      provider.toggleTheme(true);
                    },
                    title: 'Dark Mood',
                    secondry: CircleAvatar(child: Icon(Icons.dark_mode)),
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
