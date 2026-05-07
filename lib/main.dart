import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/app_colors/theme_colors.dart';
import 'package:safe_zone/core/services/background_services.dart';
import 'package:safe_zone/features/about/logic/about_provider.dart';
import 'package:safe_zone/features/change_email/logic/change_email_provider.dart';
import 'package:safe_zone/features/change_password/logic/change_password_provider.dart';
import 'package:safe_zone/features/delete_account/logic/delete_account_provider.dart';
import 'package:safe_zone/features/edit_profile/logic/edit_profile_provider.dart';
import 'package:safe_zone/features/emergency_contacts/logic/emergency_provider.dart';
import 'package:safe_zone/features/emergency_trigger/logic/emegency_trigger_provider.dart';
import 'package:safe_zone/features/faq/logic/faq_provider.dart';
import 'package:safe_zone/features/forget_password/logic/forget_password_provider.dart';
import 'package:safe_zone/features/home/data/gird_services_data.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';
import 'package:safe_zone/features/notification/logic/notification_provider.dart';
import 'package:safe_zone/features/notification/ui/notification_screen.dart';
import 'package:safe_zone/features/onboarding/logic/onboarding_provider.dart';
import 'package:safe_zone/features/personal_info/logic/personal_info_provider.dart';
import 'package:safe_zone/features/report_a_problem/logic/report_a_problem_provider.dart';
import 'package:safe_zone/features/safety_guide/logic/safety_guide_provider.dart';
import 'package:safe_zone/features/services/logic/services_provider.dart';
import 'package:safe_zone/features/settings/logic/settings_provider.dart';
import 'package:safe_zone/features/splash/ui/splash_screen.dart';
import 'package:safe_zone/features/voice_activation/logic/voice_activation_provider.dart';
import 'package:safe_zone/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:safe_zone/l10n/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  listenToVoice();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationProvider().initNotifications();
  await NotificationProvider().setupNotificationChannel();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['URL_KEY']!,
    anonKey: dotenv.env['ANON_KEY']!,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) =>
                  HomeProvider()
                    ..loadLocal()
                    ..loadTheme(),
          // ..initializeService(),
        ),
        ChangeNotifierProvider(
          create: (_) => GirdServicesData()..getCurrentLocation(),
        ),
        ChangeNotifierProvider(create: (_) => ServicesProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => EmergencyProvider()),
        ChangeNotifierProvider(
          create:
              (_) => EditProfileProvider()..init(HomeProvider().registerModel),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider()..loadSettings(),
        ),
        ChangeNotifierProvider(create: (_) => ChangeEmailProvider()),
        ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
        ChangeNotifierProvider(
          create: (_) => EmegencyTriggerProvider()..loadSettings(),
        ),
        ChangeNotifierProvider(create: (_) => VoiceActivationProvider()),
        ChangeNotifierProvider(create: (_) => PersonalInfoProvider()),
        ChangeNotifierProvider(create: (_) => FaqProvider()),
        ChangeNotifierProvider(create: (_) => SafetyGuideProvider()),
        ChangeNotifierProvider(create: (_) => ReportAProblemProvider()),
        ChangeNotifierProvider(create: (_) => AboutProvider()),
        ChangeNotifierProvider(create: (_) => DeleteAccountProvider()),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider()..initNotifications(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final provider = context.watch<HomeProvider>();
        if (provider.registerModel == null) {
          provider.getUser();
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: provider.locale,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: provider.themeMode,
          home: Scaffold(
            appBar: AppBar(
              title: Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_outlined, color: Colors.blue),
                  Text(
                    'Safe Zone',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.notifications_none_outlined,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            body: Consumer<HomeProvider>(
              builder: (context, provider, _) {
                return provider.screens[provider.currentIndex];
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue,
              unselectedItemColor: const Color.fromARGB(255, 130, 130, 130),
              currentIndex: provider.currentIndex,
              onTap: provider.channgeIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_on_outlined),
                  label: 'Location',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.apps),
                  label: 'Services',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
