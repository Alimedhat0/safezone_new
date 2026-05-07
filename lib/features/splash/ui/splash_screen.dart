import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';
import 'package:safe_zone/features/login/ui/login_screen.dart';
import 'package:safe_zone/features/onboarding/ui/onboarding_screen.dart';
import 'package:safe_zone/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    HomeProvider().getUser();
    HomeProvider().loadLocal();
    HomeProvider().loadTheme();
    Future.delayed(Duration(seconds: 3)).then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return MainApp();
                  }
                  return OnboardingScreen();
                },
              ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Image.asset('assests/images/splash_image1.png'),
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Image.asset('assests/images/safezone.png'),
            ),
          ],
        ),
      ),
    );
  }
}
