import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:safe_zone/core/aspict/app_aspict.dart';
import 'package:safe_zone/core/widgets/custom_text_field.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final newPasswordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text('Forget Password')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              child: SvgPicture.asset('assests/svgs/vector_fpassword.svg'),
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
                  controller: newPasswordController,
                  text: 'Enter Your email address',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                SizedBox(
                  width: screenWidth,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 6,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Send Reset Code',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
