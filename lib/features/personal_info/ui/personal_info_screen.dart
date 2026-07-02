import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/core/widgets/custom_text_field.dart';
import 'package:safe_zone/features/edit_profile/logic/edit_profile_provider.dart';
import 'package:safe_zone/features/edit_profile/ui/edit_profile_screen.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';
import 'package:safe_zone/features/personal_info/logic/personal_info_provider.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.tr;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider = context.read<HomeProvider>();
      final personalProvider = context.read<PersonalInfoProvider>();

      homeProvider.getUser();
      personalProvider.init(homeProvider.registerModel);
    });
    final personalProvider = context.read<PersonalInfoProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.personal_information)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<EditProfileProvider>(
                builder: (context, provider, _) {
                  return CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 50,
                    backgroundImage:
                        provider.imagePath != null
                            ? FileImage(File(provider.imagePath!))
                            : null,
                    child:
                        provider.imagePath == null
                            ? Icon(Icons.person, size: 40, color: Colors.white)
                            : null,
                  );
                },
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
                  l10n.change_photo,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Consumer<PersonalInfoProvider>(
                builder: (context, provider, _) {
                  return Column(
                    children: [
                      Form(
                        key: personalProvider.formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 20,
                            children: [
                              Text(l10n.full_name),
                              CustomTextField(
                                controller: personalProvider.nameController,
                                text: '',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return l10n.enter_your_name_alt;
                                  }
                                  return null;
                                },
                              ),
                              Text(l10n.phone_number),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: DropdownButton<String>(
                                      value: personalProvider.selectedCode,
                                      underline: SizedBox(),
                                      items:
                                          personalProvider.countryCodes.map((
                                            code,
                                          ) {
                                            return DropdownMenuItem(
                                              value: code,
                                              child: Text(code),
                                            );
                                          }).toList(),
                                      onChanged: (value) {
                                        personalProvider.selectedCode = value!;
                                      },
                                    ),
                                  ),

                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller:
                                          personalProvider.phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        hintText: l10n.phone_number,
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(l10n.email_address),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                color: Colors.grey[400],
                                child: CustomTextField(
                                  controller: personalProvider.emailController,
                                  text: '',
                                  readonly: true,
                                ),
                              ),
                              Text(l10n.date_of_birth),
                              CustomTextField(
                                readonly: true,
                                controller: provider.birthController,
                                text: '',
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  color: Colors.grey,
                                ),
                                onTap: () async {
                                  provider.pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime(2000),
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime.now(),
                                  );
                                  if (provider.pickedDate != null) {
                                    String formattedDate =
                                        '${provider.pickedDate!.day}/${provider.pickedDate!.month}/${provider.pickedDate!.year}';
                                    provider.birthController.text =
                                        formattedDate;
                                  }
                                },
                              ),
                              Text(l10n.gender),
                              DropdownButtonFormField<String>(
                                value: personalProvider.gender,
                                hint: Text(l10n.gender),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                items:
                                    personalProvider.genderList(l10n).map((
                                      gender,
                                    ) {
                                      return DropdownMenuItem(
                                        value: gender,
                                        child: Text(gender),
                                      );
                                    }).toList(),
                                onChanged: (value) {
                                  personalProvider.gender = value!;
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return l10n.please_select_gender;
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
