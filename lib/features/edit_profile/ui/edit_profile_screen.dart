import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/core/widgets/custom_text_field.dart';
import 'package:safe_zone/features/edit_profile/logic/edit_profile_provider.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final editProvider = context.read<EditProfileProvider>();
      final homeProvider = context.read<HomeProvider>();

      editProvider.init(homeProvider.registerModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.tr;
    final provider = context.read<EditProfileProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.edit_profile), centerTitle: true),
      body: Column(
        spacing: 10,
        children: [
          Consumer<EditProfileProvider>(
            builder: (context, pro, _) {
              return GestureDetector(
                onTap: () async {
                  pro.pickImage();
                  await pro.saveImage(pro.imagePath!);
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      pro.imagePath != null
                          ? FileImage(File(pro.imagePath!))
                          : null,
                  child:
                      pro.imagePath == null
                          ? Icon(Icons.person, size: 40)
                          : null,
                ),
              );
            },
          ),

          Form(
            key: provider.formKey,
            child: Column(
              spacing: 20,
              children: [
                CustomTextField(
                  controller: provider.nameController,
                  text: l10n.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.enter_your_name_alt;
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: provider.phoneController,
                  text: l10n.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.enter_your_phone;
                    }
                    return null;
                  },
                ),
                Consumer<EditProfileProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        provider.editProfile(context);
                      },
                      child: Text(
                        l10n.save,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
