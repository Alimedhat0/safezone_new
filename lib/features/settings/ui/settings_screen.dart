import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/features/delete_account/ui/delete_account_screen.dart';
import 'package:safe_zone/features/edit_profile/logic/edit_profile_provider.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';
import 'package:safe_zone/features/login/ui/login_screen.dart';
import 'package:safe_zone/features/settings/logic/settings_provider.dart';

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

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Color(0xffffffff),

              child: Row(
                // mainAxisAlignment: MainAxisAlignment.start,
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
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                            'View profile',
                            style: TextStyle(fontSize: 12, color: Colors.blue),
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
                Text('Account'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Color(0xffffffff),
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
                                    provider.cardscontent[index].title,
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
                Text('Emegency & Safety'),
                Consumer<SettingsProvider>(
                  builder: (context, provider, _) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Color(0xffffffff),
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
                                      provider.cardscontent[index + 3].preicon,
                                    ),
                                    Expanded(
                                      child: Text(
                                        provider.cardscontent[index + 3].title,
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
                                                        .cardscontent[index + 3]
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
                              onChanged: (va) {
                                provider.updateSetting('liveOn', va);
                              },
                              title: Text('Live Location Sharing'),
                            ),
                            SwitchListTile(
                              activeTrackColor: Colors.blue,

                              secondary: Icon(Icons.watch_later_outlined),
                              value: provider.settings['timeron'] ?? false,
                              onChanged: (va) {
                                provider.updateSetting('timeron', va);
                              },
                              title: Text('Auto-SOS Timer'),
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
                Text('Notifications'),
                Consumer<SettingsProvider>(
                  builder: (context, provider, _) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Color(0xffffffff),

                        elevation: 6,
                        child: Column(
                          children: [
                            SwitchListTile(
                              activeTrackColor: Colors.blue,
                              secondary: Icon(Icons.notifications_none),
                              value:
                                  provider.settings['notificationOn'] ?? false,
                              onChanged: (va) {
                                provider.updateSetting('notificationOn', va);
                              },
                              title: Text('Push Notification'),
                            ),
                            SwitchListTile(
                              activeTrackColor: Colors.blue,
                              secondary: Icon(Icons.volume_up_outlined),
                              value: provider.settings['alertSoundOn'] ?? false,
                              onChanged: (va) {
                                provider.updateSetting('alertSoundOn', va);
                              },
                              title: Text('Alert Sounds'),
                            ),
                            SwitchListTile(
                              activeTrackColor: Colors.blue,
                              secondary: Icon(Icons.vibration),
                              value:
                                  provider.settings['alertVibrationOn'] ??
                                  false,
                              onChanged: (va) {
                                provider.updateSetting('alertVibrationOn', va);
                              },
                              title: Text('Vibration Alerts'),
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
                Text('Privacy & Permissions'),
                Consumer<SettingsProvider>(
                  builder: (context, provider, _) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Color(0xffffffff),
                        elevation: 6,
                        child: Column(
                          children: [
                            SwitchListTile(
                              activeTrackColor: Colors.blue,
                              secondary: Icon(Icons.location_on_outlined),
                              value:
                                  provider.settings['locationAccOn'] ?? false,
                              onChanged: (va) {
                                provider.updateSetting('locationAccOn', va);
                              },
                              title: Text('Location Access'),
                            ),
                            SwitchListTile(
                              activeTrackColor: Colors.blue,
                              secondary: Icon(Icons.camera_alt_outlined),
                              value: provider.settings['cameraAccOn'] ?? false,
                              onChanged: (va) {
                                provider.updateSetting('cameraAccOn', va);
                              },
                              title: Text('Camera Access'),
                            ),
                            SwitchListTile(
                              activeTrackColor: Colors.blue,
                              secondary: Icon(Icons.mic_none_outlined),
                              value: provider.settings['micAccOn'] ?? false,
                              onChanged: (va) {
                                provider.updateSetting('micAccOn', va);
                              },
                              title: Text('Microphone Access'),
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
                Text('App Preferences'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Color(0xffffffff),
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
                                Icon(provider.cardscontent[index + 5].preicon),
                                Expanded(
                                  child: Text(
                                    provider.cardscontent[index + 5].title,
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
                Text('Help & Support'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Color(0xffffffff),
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
                                Icon(provider.cardscontent[index + 7].preicon),
                                Expanded(
                                  child: Text(
                                    provider.cardscontent[index + 7].title,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Log Out',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    Text('Are you sure you want to log out?'),
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
                                              'Log Out',
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
                                              backgroundColor: Colors.grey[600],
                                            ),
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: Text(
                                              'Cancel',
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
                    child: Text('Log Out'),
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
                      'Delete Account',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
