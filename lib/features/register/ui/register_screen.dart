import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/aspict/app_aspict.dart';
import 'package:safe_zone/core/widgets/custom_text_field.dart';
import 'package:safe_zone/features/login/ui/login_screen.dart';
import 'package:safe_zone/features/register/logic/register_provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterProvider(),
      builder: (context, child) {
        final regProvider = context.read<RegisterProvider>();
        return Scaffold(
          appBar: AppBar(title: Text('Sign Up'), centerTitle: true),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.1),
                Consumer<RegisterProvider>(
                  builder: (context, value, child) {
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
                              text: 'Full Name',
                              prefixIcon: Icon(Icons.person_outline),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Your Name';
                                }
                                return null;
                              },
                            ),
                          ),
                          CustomTextField(
                            controller: regProvider.emailController,
                            text: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          CustomTextField(
                            controller: regProvider.passwordController,
                            text: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_red_eye_outlined),
                              onPressed: () {},
                            ),
                          ),
                          CustomTextField(
                            controller: regProvider.phoneController,
                            text: 'Phone Number',
                            prefixIcon: Icon(Icons.phone),
                          ),

                          regProvider.isLoading == true
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
                                    'Sign Up',
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
                            height: 50,

                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 6,
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () {},
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
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Log In',
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
