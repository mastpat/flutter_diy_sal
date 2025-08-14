import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_config.dart';
import 'providers/onboarding_provider.dart';
import 'screens/main_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/personal_details_screen.dart';
import 'screens/address_details_screen.dart';
import 'screens/family_details_screen.dart';
import 'screens/nominee_details_screen.dart';
import 'screens/steps_screen.dart';
import 'screens/summary_page.dart';
import 'screens/account_opening_screen.dart';
import 'repositories/local_storage.dart';

/// Entry point for the DIY Journey Flutter app.
///
/// Note:
/// - The app is configured to start directly at '/main' per user instruction.
///   If you want to show the SplashScreen first, set initialRoute to '/'.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  runApp(DIYJourneyApp());
}

class DIYJourneyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // OnboardingProvider will load its data from LocalStorage automatically.
        ChangeNotifierProvider<OnboardingProvider>(
          create: (_) => OnboardingProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'DIY Journey',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // The app launches directly to MainScreen to bypass checks as requested.
        // To show the splash screen first, change initialRoute to '/'.
        initialRoute: '/startJourney',
        routes: {
          '/': (_) => SplashScreen(),
          '/startJourney': (_) => AccountOpeningScreen(),
          '/main': (_) => MainScreen(),
          '/steps': (_) => StepsScreen(),
          '/personal': (_) => PersonalDetailsScreen(),
          '/address': (_) => AddressDetailsScreen(),
          '/family': (_) => FamilyDetailsScreen(),
          '/nominee': (_) => NomineeDetailsScreen(),
          '/summary': (_) => SummaryPage(),
        },
      ),
    );
  }
}
