import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/aspict/app_aspict.dart';
import 'package:safe_zone/core/widgets/custom_text_field.dart';
import 'package:safe_zone/features/forget_password/ui/forget_password_screen.dart';
import 'package:safe_zone/features/login/logic/login_provider.dart';
import 'package:safe_zone/features/register/ui/register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginProvider(),
      child: Scaffold(
        appBar: AppBar(title: Text('Log in')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.15, width: screenWidth),
              Consumer<LoginProvider>(
                builder: (context, provider, child) {
                  return Form(
                    key: provider.formKey,
                    child: Column(
                      spacing: 10,
                      children: [
                        CustomTextField(
                          controller: provider.emailController,
                          text: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          controller: provider.passwordController,
                          text: 'Password',
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: Icon(Icons.remove_red_eye_outlined),

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Password';
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
                            'Forget Password?',
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
                                  'Log in',
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
                              child: Text('or'),
                            ),
                            SizedBox(
                              width: screenWidth * 0.4,
                              child: Divider(thickness: 2),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: screenWidth,
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
                                Text('Continue with Google'),
                              ],
                            ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
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
                                'Sign Up',
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
