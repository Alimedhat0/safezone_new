import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/widgets/custom_text_field.dart';
import 'package:safe_zone/features/change_password/logic/change_password_provider.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final globalProvider = context.read<ChangePasswordProvider>();
    final homeProvider = context.read<HomeProvider>();

    if (homeProvider.registerModel == null) {
      homeProvider.getUser();
    }
    return Scaffold(
      appBar: AppBar(title: Text('Change Password'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Text(
              'Enter your current password and choose a new one to secure your account.',
            ),
            Text(
              'Current Password',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            Consumer<ChangePasswordProvider>(
              builder: (context, provider, _) {
                return Form(
                  key: provider.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      CustomTextField(
                        controller: globalProvider.currentPasswordController,
                        text: 'Enter current password',
                        suffixIcon: Icon(Icons.lock_outline),
                      ),
                      Text(
                        'New Password',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      CustomTextField(
                        controller: provider.newPasswordController,
                        text: 'Enter new password',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new Password';
                          }
                          return null;
                        },
                      ),
                      Text(
                        'Confirm New Password',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      CustomTextField(
                        controller: provider.confirmPasswordController,
                        text: 'Re-enter new password',
                        validator: (value) {
                          if (value != provider.newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            // if (!provider.formKey.currentState!.validate())
                            //   return;

                            // showDialog(
                            //   context: context,
                            //   builder: (context) {
                            //     return AlertDialog(
                            //       title: Text('Confirm Password'),
                            //       content: Column(
                            //         mainAxisSize: MainAxisSize.min,
                            //         children: [
                            //           CustomTextField(
                            //             controller: provider.passwordController,
                            //             text: 'Password',
                            //           ),
                            //         ],
                            //       ),

                            //       actions: [
                            //         provider.isLoading
                            //             ? CircularProgressIndicator()
                            //             : ElevatedButton(
                            //               onPressed: () async {
                            //                 await provider.updatePassword(
                            //                   provider
                            //                       .newPasswordController
                            //                       .text,
                            //                   provider
                            //                       .currentPasswordController
                            //                       .text,
                            //                 );

                            //                 await homeProvider.getUser();
                            //                 Navigator.pop(context);
                            //               },
                            //               child: Text('Update'),
                            //             ),
                            //       ],
                            //     );
                            //   },
                            // );
                            provider.updatePassword(
                              provider.newPasswordController.text,
                              provider.currentPasswordController.text,
                            );
                          },
                          child: Text(
                            'Send Verification Code',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
