import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/aspict/app_aspict.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/core/widgets/custom_text_field.dart';
import 'package:safe_zone/features/login/logic/login_provider.dart';
import 'package:safe_zone/features/login/ui/login_screen.dart';
import 'package:safe_zone/features/register/logic/register_provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.tr;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RegisterProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
      ],
      builder: (context, child) {
        final regProvider = context.read<RegisterProvider>();
        return Scaffold(
          appBar: AppBar(title: Text(l10n.sign_up), centerTitle: true),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.asset(
                  'assests/images/safezoneupdatedicon.png',
                  height: 150,
                ),
                Consumer2<RegisterProvider, LoginProvider>(
                  builder: (context, value, loginProvider, child) {
                    return Form(
                      key: regProvider.formKey,
                      child: Column(
                        spacing: 15,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 6,
                            child: CustomTextField(
                              controller: regProvider.nameController,
                              text: l10n.full_name,
                              prefixIcon: Icon(Icons.person_outline),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.enter_your_name;
                                }
                                return null;
                              },
                            ),
                          ),
                          CustomTextField(
                            controller: regProvider.emailController,
                            text: l10n.email,
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          CustomTextField(
                            controller: regProvider.passwordController,
                            text: l10n.password,
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: Icon(Icons.remove_red_eye_outlined),
                          ),
                          CustomTextField(
                            controller: regProvider.phoneController,
                            text: l10n.phone_number,
                            prefixIcon: Icon(Icons.phone),
                          ),

                          regProvider.isLoading == true ||
                                  loginProvider.isLoading == true
                              ? CircularProgressIndicator()
                              : SizedBox(
                                width: screenWidth,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 6,
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: () {
                                    regProvider.register(context);
                                  },
                                  child: Text(
                                    l10n.sign_up,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
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
                            width: screenWidth,
                            height: 50,

                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 6,
                                backgroundColor: Colors.white,
                              ),
                              onPressed:
                                  loginProvider.isLoading ||
                                          regProvider.isLoading
                                      ? null
                                      : () => loginProvider.signInWithGoogle(
                                        context,
                                      ),
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
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  l10n.log_in_alt,
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
        );
      },
    );
  }
}
