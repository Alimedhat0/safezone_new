import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/core/widgets/custom_text_field.dart';
import 'package:safe_zone/features/forget_password/logic/forget_password_provider.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.tr;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.forget_password)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Consumer<ForgotPasswordProvider>(
          builder: (context, provider, _) {
            return Form(
              key: provider.formKey,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    child: SvgPicture.asset(
                      'assests/svgs/vector_fpassword.svg',
                    ),
                  ),
                  Text(
                    l10n.reset_your_password,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    l10n.enter_email_to_receive_reset_code,
                    style: TextStyle(color: Colors.grey),
                  ),
                  Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.email_address,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomTextField(
                        controller: provider.emailController,
                        text: l10n.enter_your_email_address,
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            elevation: 6,
                          ),
                          onPressed:
                              provider.isLoading
                                  ? null
                                  : () async {
                                    await provider.resetPassword(context);
                                  },
                          child:
                              provider.isLoading
                                  ? CircularProgressIndicator()
                                  : Text(
                                    l10n.send_reset_link,
                                    style: TextStyle(color: Colors.white),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
