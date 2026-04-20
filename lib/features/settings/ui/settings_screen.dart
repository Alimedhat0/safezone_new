import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
                              child: Text(provider.cardscontent[index].title),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            provider.cardscontent[index].screen,
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
                                Icon(provider.cardscontent[index + 3].preicon),
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
                          value: provider.liveOn,
                          onChanged: (va) {
                            provider.liveOn = !provider.liveOn;
                          },
                          title: Text('Live Location Sharing'),
                        ),
                        SwitchListTile(
                          activeTrackColor: Colors.blue,

                          secondary: Icon(Icons.watch_later_outlined),
                          value: provider.timeron,
                          onChanged: (va) {
                            provider.timeron = !provider.timeron;
                          },
                          title: Text('Auto-SOS Timer'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
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
                          value: provider.notificationOn,
                          onChanged: (va) {
                            provider.notificationOn = !provider.notificationOn;
                          },
                          title: Text('Push Notification'),
                        ),
                        SwitchListTile(
                          activeTrackColor: Colors.blue,

                          secondary: Icon(Icons.volume_up_outlined),
                          value: provider.alertSoundOn,
                          onChanged: (va) {
                            provider.alertSoundOn = !provider.alertSoundOn;
                          },
                          title: Text('Alert Sounds'),
                        ),
                        SwitchListTile(
                          activeTrackColor: Colors.blue,

                          secondary: Icon(Icons.vibration),
                          value: provider.alertVibrationOn,
                          onChanged: (va) {
                            provider.alertVibrationOn =
                                !provider.alertVibrationOn;
                          },
                          title: Text('Vibration Alerts'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
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
                          value: provider.locationAccOn,
                          onChanged: (va) {
                            provider.locationAccOn = !provider.locationAccOn;
                          },
                          title: Text('Location Access'),
                        ),
                        SwitchListTile(
                          activeTrackColor: Colors.blue,

                          secondary: Icon(Icons.camera_alt_outlined),
                          value: provider.cameraAccOn,
                          onChanged: (va) {
                            provider.cameraAccOn = !provider.cameraAccOn;
                          },
                          title: Text('Camera Access'),
                        ),
                        SwitchListTile(
                          activeTrackColor: Colors.blue,

                          secondary: Icon(Icons.mic_none_outlined),
                          value: provider.micAccOn,
                          onChanged: (va) {
                            provider.micAccOn = !provider.micAccOn;
                          },
                          title: Text('Microphone Access'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
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
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text('Log Out'),
                  ),
                  TextButton(
                    onPressed: () {},
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
