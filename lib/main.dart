import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/services/auth_service.dart';
import 'features/auth/views/auth_screen.dart';
import 'features/onboarding/views/onboarding_screen.dart';
import 'features/home/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final bool onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
  runApp(ZylookApp(onboardingCompleted: onboardingCompleted));
}

class ZylookApp extends StatelessWidget {
  final bool onboardingCompleted;

  const ZylookApp({required this.onboardingCompleted, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Zylook',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: onboardingCompleted ? '/auth' : '/onboarding',
        routes: {
          '/onboarding': (context) => const OnboardingScreen(),
          '/auth': (context) => const AuthScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zylook Home')),
      body: const Center(child: Text('Welcome to Zylook!')),
    );
  }
}