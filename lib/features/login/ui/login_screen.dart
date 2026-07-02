import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/aspict/app_aspict.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/core/widgets/custom_text_field.dart';
import 'package:safe_zone/features/forget_password/ui/forget_password_screen.dart';
import 'package:safe_zone/features/login/logic/login_provider.dart';
import 'package:safe_zone/features/register/ui/register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.tr;

    return ChangeNotifierProvider(
      create: (context) => LoginProvider(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.login_title), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assests/images/safezoneupdatedicon.png',
                height: 150,
              ),
              Consumer<LoginProvider>(
                builder: (context, provider, child) {
                  return Form(
                    key: provider.formKey,
                    child: Column(
                      spacing: 10,
                      children: [
                        CustomTextField(
                          controller: provider.emailController,
                          text: l10n.email,
                          prefixIcon: Icon(Icons.email_outlined),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.please_enter_your_email;
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          controller: provider.passwordController,
                          text: l10n.password,
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon:
                              provider.isvisible
                                  ? IconButton(
                                    icon: Icon(Icons.visibility_off_outlined),
                                    onPressed: () {
                                      provider.togglePasswordVisibility();
                                    },
                                  )
                                  : IconButton(
                                    icon: Icon(Icons.remove_red_eye_outlined),
                                    onPressed: () {
                                      provider.togglePasswordVisibility();
                                    },
                                  ),
                          obscureText: provider.isvisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.please_enter_your_password;
                            }
                            return null;
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgetPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            l10n.forget_password_question,
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        provider.isLoading
                            ? CircularProgressIndicator()
                            : SizedBox(
                              width: screenWidth,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 6,
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  provider.login(context);
                                },
                                child: Text(
                                  l10n.login_title,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: screenWidth * 0.4,
                              child: Divider(thickness: 2),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ),
                              child: Text(l10n.or),
                            ),
                            SizedBox(
                              width: screenWidth * 0.4,
                              child: Divider(thickness: 2),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 6,
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              var userCredential =
                                  await provider.signInWithGoogle();

                              if (userCredential != null) {
                                User user = userCredential.user!;
                                await provider.saveUser(user);
                                print(user);
                              }
                            },
                            child: Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assests/icons/google.svg'),
                                Text(l10n.continue_with_google),
                              ],
                            ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.dont_have_an_account,
                              style: TextStyle(color: Colors.blue),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                l10n.sign_up,
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
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
            ],
          ),
        ),
      ),
    );
  }
}
