import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/features/delete_account/ui/delete_account_screen.dart';
import 'package:safe_zone/features/edit_profile/logic/edit_profile_provider.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';
import 'package:safe_zone/features/login/ui/login_screen.dart';
import 'package:safe_zone/features/settings/logic/settings_provider.dart';
import 'package:safe_zone/l10n/generated/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final proProvider =
        context.watch<EditProfileProvider>()
          ..init(HomeProvider().registerModel);
    final homeProvider = context.watch<HomeProvider>();
    context.watch<HomeProvider>().getUser();
    final provider = context.watch<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            proProvider.imagePath != null
                                ? FileImage(File(proProvider.imagePath!))
                                : null,
                        child:
                            proProvider.imagePath == null
                                ? Icon(Icons.person, size: 40)
                                : null,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                            ),
                            child: Text(
                              homeProvider.registerModel!.name,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              homeProvider.channgeIndex(3);
                            },
                            child: Text(
                              l10n.view_profile,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        homeProvider.channgeIndex(3);
                      },
                      icon: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.account),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 6,
                      child: Column(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Row(
                                spacing: 10,
                                children: [
                                  SizedBox(width: 10),
                                  Icon(provider.cardscontent[index].preicon),
                                  Expanded(
                                    child: Text(
                                      provider.cardscontent[index].title(l10n),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  provider
                                                      .cardscontent[index]
                                                      .screen,
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.arrow_forward_ios),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder:
                                (context, index) => Divider(thickness: 1),
                            itemCount: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.emergency_and_safety),
                  Consumer<SettingsProvider>(
                    builder: (context, provider, _) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 6,
                          child: Column(
                            children: [
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Row(
                                    spacing: 10,
                                    children: [
                                      SizedBox(width: 10),
                                      Icon(
                                        provider
                                            .cardscontent[index + 3]
                                            .preicon,
                                      ),
                                      Expanded(
                                        child: Text(
                                          provider.cardscontent[index + 3]
                                              .title(l10n),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      provider
                                                          .cardscontent[index +
                                                              3]
                                                          .screen,
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.arrow_forward_ios),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder:
                                    (context, index) => Divider(thickness: 1),
                                itemCount: 2,
                              ),

                              SwitchListTile(
                                activeTrackColor: Colors.blue,
                                secondary: Icon(Icons.location_on_outlined),
                                value: provider.settings['liveOn'] ?? false,
                                onChanged: (va) async {
                                  await provider.updateSetting(
                                    'liveOn',
                                    va,
                                    l10n: l10n,
                                  );
                                },
                                title: Text(l10n.live_location_sharing),
                              ),
                              SwitchListTile(
                                activeTrackColor: Colors.blue,

                                secondary: Icon(Icons.watch_later_outlined),
                                value: provider.settings['timeron'] ?? false,
                                onChanged: (va) async {
                                  await provider.updateSetting(
                                    'timeron',
                                    va,
                                    l10n: l10n,
                                  );
                                },
                                title: Text(l10n.auto_sos_timer),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.notifications),
                  Consumer<SettingsProvider>(
                    builder: (context, provider, _) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 6,
                          child: Column(
                            children: [
                              SwitchListTile(
                                activeTrackColor: Colors.blue,
                                secondary: Icon(Icons.notifications_none),
                                value:
                                    provider.settings['notificationOn'] ??
                                    false,
                                onChanged: (va) async {
                                  await provider.updateSetting(
                                    'notificationOn',
                                    va,
                                    l10n: l10n,
                                  );
                                },
                                title: Text(l10n.push_notification),
                              ),
                              SwitchListTile(
                                activeTrackColor: Colors.blue,
                                secondary: Icon(Icons.volume_up_outlined),
                                value:
                                    provider.settings['alertSoundOn'] ?? false,
                                onChanged: (va) async {
                                  await provider.updateSetting(
                                    'alertSoundOn',
                                    va,
                                    l10n: l10n,
                                  );
                                },
                                title: Text(l10n.alert_sounds),
                              ),
                              SwitchListTile(
                                activeTrackColor: Colors.blue,
                                secondary: Icon(Icons.vibration),
                                value:
                                    provider.settings['alertVibrationOn'] ??
                                    false,
                                onChanged: (va) async {
                                  await provider.updateSetting(
                                    'alertVibrationOn',
                                    va,
                                    l10n: l10n,
                                  );
                                },
                                title: Text(l10n.vibration_alerts),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.privacy_and_permissions),
                  Consumer<SettingsProvider>(
                    builder: (context, provider, _) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 6,
                          child: Column(
                            children: [
                              SwitchListTile(
                                activeTrackColor: Colors.blue,
                                secondary: Icon(Icons.location_on_outlined),
                                value:
                                    provider.settings['locationAccOn'] ?? false,
                                onChanged: (va) async {
                                  await provider.updateSetting(
                                    'locationAccOn',
                                    va,
                                    l10n: l10n,
                                  );
                                },
                                title: Text(l10n.location_access),
                              ),
                              SwitchListTile(
                                activeTrackColor: Colors.blue,
                                secondary: Icon(Icons.camera_alt_outlined),
                                value:
                                    provider.settings['cameraAccOn'] ?? false,
                                onChanged: (va) async {
                                  await provider.updateSetting(
                                    'cameraAccOn',
                                    va,
                                    l10n: l10n,
                                  );
                                },
                                title: Text(l10n.camera_access),
                              ),
                              SwitchListTile(
                                activeTrackColor: Colors.blue,
                                secondary: Icon(Icons.mic_none_outlined),
                                value: provider.settings['micAccOn'] ?? false,
                                onChanged: (va) async {
                                  await provider.updateSetting(
                                    'micAccOn',
                                    va,
                                    l10n: l10n,
                                  );
                                },
                                title: Text(l10n.microphone_access),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.app_preferences),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 6,
                      child: Column(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Row(
                                spacing: 10,
                                children: [
                                  SizedBox(width: 10),
                                  Icon(
                                    provider.cardscontent[index + 5].preicon,
                                  ),
                                  Expanded(
                                    child: Text(
                                      provider.cardscontent[index + 5].title(
                                        l10n,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  provider
                                                      .cardscontent[index + 5]
                                                      .screen,
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.arrow_forward_ios),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder:
                                (context, index) => Divider(thickness: 1),
                            itemCount: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.help_and_support),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 6,
                      child: Column(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Row(
                                spacing: 10,
                                children: [
                                  SizedBox(width: 10),
                                  Icon(
                                    provider.cardscontent[index + 7].preicon,
                                  ),
                                  Expanded(
                                    child: Text(
                                      provider.cardscontent[index + 7].title(
                                        l10n,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  provider
                                                      .cardscontent[index + 7]
                                                      .screen,
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.arrow_forward_ios),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder:
                                (context, index) => Divider(thickness: 1),
                            itemCount: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AlertDialog(
                                  content: Column(
                                    spacing: 16,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        l10n.log_out,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                      Text(l10n.confirm_log_out_message),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              ),
                                              onPressed: () async {
                                                await FirebaseAuth.instance
                                                    .signOut();
                                                if (!context.mounted) return;
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            LoginScreen(),
                                                  ),
                                                );
                                                provider.clearUid();
                                              },
                                              child: Text(
                                                l10n.log_out,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[600],
                                              ),
                                              onPressed:
                                                  () => Navigator.pop(context),
                                              child: Text(
                                                l10n.cancel,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(l10n.log_out),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeleteAccountScreen(),
                          ),
                        );
                      },
                      child: Text(
                        l10n.delete_account,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
