import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/aspict/app_aspict.dart';
import 'package:safe_zone/features/edit_profile/logic/edit_profile_provider.dart';
import 'package:safe_zone/features/edit_profile/ui/edit_profile_screen.dart';
import 'package:safe_zone/features/home/data/gird_services_data.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        // final provider = context.read<EditProfileProvider>();
        context.read<GirdServicesData>().getCurrentLocation();
        final homeProvider = context.watch<HomeProvider>()..getUser();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Consumer<EditProfileProvider>(
                builder: (context, provider, _) {
                  return CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        provider.imagePath != null
                            ? FileImage(File(provider.imagePath!))
                            : null,
                    child:
                        provider.imagePath == null
                            ? Icon(Icons.person, size: 40)
                            : null,
                  );
                },
              ),
              Text(homeProvider.registerModel!.name),
              Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Active'),
                  Icon(Icons.circle, color: Colors.greenAccent, size: 10),
                ],
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ),
                  );
                },
                child: Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Basic Information'),
                    ),
                    Card(
                      color: Colors.white,
                      margin: EdgeInsets.all(8),
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 8,
                        ),
                        child: Column(
                          spacing: 16,
                          children: [
                            basicInfoItem(
                              icon: Icons.call,
                              text: homeProvider.registerModel!.phone,
                            ),
                            Divider(height: 1),
                            basicInfoItem(
                              icon: Icons.email_outlined,
                              text: homeProvider.registerModel!.email,
                            ),
                            Divider(height: 1),
                            Consumer<GirdServicesData>(
                              builder: (context, pro, _) {
                                return basicInfoItem(
                                  icon: Icons.location_on_outlined,
                                  text: pro.locationName.toString(),
                                );
                              },
                            ),
                            Divider(height: 1),
                            basicInfoItem(
                              icon: Icons.person_outlined,
                              text: homeProvider.registerModel!.name,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 6,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          spacing: 10,
                          children: [
                            Icon(
                              Icons.watch_later_outlined,
                              color: Colors.blue,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'History',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'View Pervious reports',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class basicInfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const basicInfoItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blue),
            SizedBox(width: 8),
            Text(text),
          ],
        ),
      ],
    );
  }
}
