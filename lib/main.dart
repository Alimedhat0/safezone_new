import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/features/edit_profile/logic/edit_profile_provider.dart';
import 'package:safe_zone/features/emergency_contacts/logic/emergency_provider.dart';
import 'package:safe_zone/features/emergency_contacts/ui/emergency_contact_screen.dart';
import 'package:safe_zone/features/home/data/gird_services_data.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';
import 'package:safe_zone/features/personal_info/logic/personal_info_provider.dart';
import 'package:safe_zone/features/services/logic/services_provider.dart';
import 'package:safe_zone/features/settings/logic/settings_provider.dart';
import 'package:safe_zone/features/splash/ui/splash_screen.dart';
import 'package:safe_zone/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['URL_KEY']!,
    anonKey: dotenv.env['ANON_KEY']!,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(
          create: (_) => GirdServicesData()..getCurrentLocation(),
        ),
        ChangeNotifierProvider(create: (_) => ServicesProvider()),
        ChangeNotifierProvider(create: (_) => EmergencyProvider()),
        ChangeNotifierProvider(
          create:
              (_) => EditProfileProvider()..init(HomeProvider().registerModel),
        ),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => PersonalInfoProvider()),
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
          debugShowCheckedModeBanner: false,
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
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_none_outlined,
                    color: Colors.blue,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    GirdServicesData().stopTracking();
                  },
                  icon: Icon(Icons.stop, color: Colors.blue),
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
          routes: {'/emergency_screen': (context) => EmergencyContactScreen()},
        );
      },
    );
  }
}
