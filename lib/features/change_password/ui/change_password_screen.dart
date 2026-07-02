import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/core/widgets/custom_text_field.dart';
import 'package:safe_zone/features/change_password/logic/change_password_provider.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.tr;
    final globalProvider = context.read<ChangePasswordProvider>();
    final homeProvider = context.read<HomeProvider>();

    if (homeProvider.registerModel == null) {
      homeProvider.getUser();
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.change_password), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Text(l10n.change_password_description),
            Text(
              l10n.current_password,
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
                        text: l10n.enter_current_password,
                        suffixIcon: Icon(Icons.lock_outline),
                      ),
                      Text(
                        l10n.new_password,
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      CustomTextField(
                        controller: provider.newPasswordController,
                        text: l10n.enter_new_password,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.please_enter_a_new_password;
                          }
                          return null;
                        },
                      ),
                      Text(
                        l10n.confirm_new_password,
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      CustomTextField(
                        controller: provider.confirmPasswordController,
                        text: l10n.reenter_new_password,
                        validator: (value) {
                          if (value != provider.newPasswordController.text) {
                            return l10n.passwords_do_not_match;
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
                            provider.updatePassword(
                              context,
                              provider.newPasswordController.text,
                              provider.currentPasswordController.text,
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
