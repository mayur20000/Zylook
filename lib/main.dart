import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/onboarding/views/onboarding_screen.dart';
import 'features/auth/login_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
  runApp(ZylookApp(onboardingCompleted: onboardingCompleted));
}

class ZylookApp extends StatelessWidget {
  final bool onboardingCompleted;

  const ZylookApp({required this.onboardingCompleted, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zylook',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: onboardingCompleted ? '/login' : '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(), // Replace with your login screen
      },
    );
  }
}