import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/widgets/custom_text_field.dart';
import 'package:safe_zone/features/change_email/logic/change_email_provider.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';
import 'package:safe_zone/features/login/logic/login_provider.dart';

class ChangeEmailScreen extends StatelessWidget {
  const ChangeEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final globalProvider = context.read<ChangeEmailProvider>();
    final homeProvider = context.read<HomeProvider>();

    if (homeProvider.registerModel == null) {
      homeProvider.getUser();
    }
    return Scaffold(
      appBar: AppBar(title: Text('Change Email'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Text(
              'Update your email address. We will send you a verification code to confirm the change.\nPlease check your gmail SPAM after update',
            ),
            Text(
              'Current Email',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            Consumer<ChangeEmailProvider>(
              builder: (context, provider, _) {
                return Form(
                  key: provider.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      CustomTextField(
                        controller: globalProvider.oldEmailController,
                        text: homeProvider.registerModel!.email,
                        readonly: true,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.lock_outline),
                          onPressed: () {
                            // Handle suffix icon press
                          },
                        ),
                      ),
                      Text(
                        'New Email Address',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      CustomTextField(
                        controller: provider.newEmailController,
                        text: 'Enter new email address',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icon(Icons.email),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new email address';
                          }
                          return null;
                        },
                      ),
                      Text(
                        'Confirm New Email',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      CustomTextField(
                        controller: provider.confirmEmailController,
                        text: 'Re-enter new email address',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != provider.newEmailController.text) {
                            return 'Please enter a new email address';
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
                            if (!provider.formKey.currentState!.validate())
                              return;

                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Confirm Password'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomTextField(
                                        controller: provider.passwordController,
                                        text: 'Password',
                                        obscureText: true,
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.lock_outline),
                                          onPressed: () {},
                                        ),
                                      ),
                                    ],
                                  ),

                                  actions: [
                                    provider.isLoading
                                        ? CircularProgressIndicator()
                                        : ElevatedButton(
                                          onPressed: () async {
                                            await provider.updateEmail(
                                              provider.passwordController.text,
                                            );
                                            await homeProvider.getUser();
                                            Navigator.pop(context);
                                          },
                                          child: Text('Update'),
                                        ),
                                  ],
                                );
                              },
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
