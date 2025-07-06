import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/services/auth_service.dart';
import 'features/auth/views/auth_selection_screen.dart';
import 'features/auth/views/phone_auth_screen.dart';
import 'features/auth/views/login_screen.dart';
import 'features/auth/views/signup_screen.dart';
import 'features/onboarding/views/onboarding_screen.dart';
import 'features/home/views/home_screen.dart';

void main() async {
  // Ensure that Flutter bindings are initialized before calling native code.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for the application.
  await Firebase.initializeApp();

  // Get an instance of SharedPreferences to check onboarding status.
  final prefs = await SharedPreferences.getInstance();
  final bool onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

  // Run the main application widget.
  runApp(ZylookApp(onboardingCompleted: onboardingCompleted));
}

class ZylookApp extends StatelessWidget {
  final bool onboardingCompleted;

  const ZylookApp({
    required this.onboardingCompleted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Use MultiProvider to provide services to the widget tree.
    return MultiProvider(
      providers: [
        // Provide the AuthService to the entire app.
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Zylook',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // Determine the initial route based on whether onboarding is complete.
        initialRoute: onboardingCompleted ? '/auth_selection' : '/onboarding',
        // Define the application's routes for navigation.
        routes: {
          '/onboarding': (context) => const OnboardingScreen(),
          '/auth_selection': (context) => const AuthSelectionScreen(),
          '/phone_auth': (context) => const PhoneAuthScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/home': (context) => const HomeScreen(),
        },
        // Handle any unknown routes by redirecting to the auth selection screen.
        onUnknownRoute: (settings) {
          // This is a fallback for any route that is not defined.
          print('Unknown route requested: ${settings.name}');
          return MaterialPageRoute(
            builder: (context) => const AuthSelectionScreen(),
          );
        },
      ),
    );
  }
}


