import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/core/widgets/custom_text_field.dart';
import 'package:safe_zone/features/change_email/logic/change_email_provider.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';

class ChangeEmailScreen extends StatelessWidget {
  const ChangeEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.tr;
    final globalProvider = context.read<ChangeEmailProvider>();
    final homeProvider = context.read<HomeProvider>();

    if (homeProvider.registerModel == null) {
      homeProvider.getUser();
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.change_email), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Text(l10n.change_email_description),
            Text(
              l10n.current_email,
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
                        suffixIcon: Icon(Icons.lock_outline),
                      ),
                      Text(
                        l10n.new_email_address,
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      CustomTextField(
                        controller: provider.newEmailController,
                        text: l10n.enter_new_email_address,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icon(Icons.email),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.please_enter_a_new_email_address;
                          }
                          return null;
                        },
                      ),
                      Text(
                        l10n.confirm_new_email,
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      CustomTextField(
                        controller: provider.confirmEmailController,
                        text: l10n.reenter_new_email_address,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != provider.newEmailController.text) {
                            return l10n.please_enter_a_new_email_address;
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
                                  title: Text(l10n.confirm_password),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomTextField(
                                        controller: provider.passwordController,
                                        text: l10n.password,
                                        obscureText: true,
                                        suffixIcon: Icon(Icons.lock_outline),
                                      ),
                                    ],
                                  ),

                                  actions: [
                                    provider.isLoading
                                        ? CircularProgressIndicator()
                                        : ElevatedButton(
                                          onPressed: () async {
                                            await provider.updateEmail(
                                              context,
                                              provider.passwordController.text,
                                            );
                                            await homeProvider.getUser();
                                            Navigator.pop(context);
                                          },
                                          child: Text(l10n.update),
                                        ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            l10n.send_verification_code,
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
