import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/widgets/custom_text_field.dart';
import 'package:safe_zone/features/forget_password/logic/forget_password_provider.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forget Password')),
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
                    'Reset Your Passwprd',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Enter Your email to receive a reset code.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email Address',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      CustomTextField(
                        controller: provider.emailController,
                        text: 'Enter Your email address',
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
                                    await provider.resetPassword();
                                  },
                          child:
                              provider.isLoading
                                  ? CircularProgressIndicator()
                                  : Text(
                                    "Send Reset Link",
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
