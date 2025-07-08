// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart'; // Keep if you use Provider elsewhere
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Flutter BLoC

// Auth Feature Imports
import 'package:zylook/features/auth/services/auth_service.dart';
import 'package:zylook/features/auth/views/auth_selection_screen.dart';
import 'package:zylook/features/auth/views/phone_auth_screen.dart';
import 'package:zylook/features/auth/views/login_screen.dart';
import 'package:zylook/features/auth/views/signup_screen.dart';

// Onboarding Feature Import
import 'package:zylook/features/onboarding/views/onboarding_screen.dart';

// Home Feature Imports
import 'package:zylook/features/home/views/home_screen.dart';
import 'package:zylook/features/home/views/outfit_detail_screen.dart';
import 'package:zylook/features/home/bloc/home_bloc.dart';
import 'package:zylook/features/home/models/outfit_model.dart';

// Cart Feature Imports
import 'package:zylook/features/cart/views/cart_screen.dart';
import 'package:zylook/features/cart/bloc/cart_bloc.dart'; // <-- THIS IS THE KEY IMPORT
import 'package:zylook/features/cart/services/cart_service.dart';
import 'package:zylook/firebase_options.dart';

import 'features/cart/bloc/cart_event.dart'; // Make sure you have this if using FlutterFire

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for the application.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Get an instance of SharedPreferences to check onboarding status.
  final prefs = await SharedPreferences.getInstance();
  final bool onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

  runApp(
    MultiProvider( // Using MultiProvider from 'provider' package if you still need it
      providers: [
        // Your existing AuthService provider
        Provider<AuthService>(create: (_) => AuthService()),
        // Add all your BLoC providers here for app-wide access
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(), // HomeBloc will initialize its HomeService internally
        ),
        BlocProvider<CartBloc>( // This line and the one below are where the error occurs
          create: (context) => CartBloc(cartService: CartService())..add(LoadCartItems()),
        ),
        // Add your AuthBloc here if you have one, e.g.:
        // BlocProvider<AuthBloc>(
        //   create: (context) => AuthBloc(authService: context.read<AuthService>()),
        // ),
      ],
      child: ZylookApp(onboardingCompleted: onboardingCompleted),
    ),
  );
}

class ZylookApp extends StatelessWidget {
  final bool onboardingCompleted;

  const ZylookApp({
    required this.onboardingCompleted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zylook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF0F0F0), // Consistent app bar background
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
        '/cart': (context) => const CartScreen(), // New Cart Screen Route
      },
      // Use onGenerateRoute for routes that require arguments, like OutfitDetailScreen
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/outfit_detail':
            final args = settings.arguments;
            if (args is Outfit) {
              return MaterialPageRoute(
                builder: (context) => OutfitDetailScreen(outfit: args),
              );
            }
            // Handle error or redirect if arguments are missing/incorrect
            return MaterialPageRoute(builder: (context) => const Text('Error: Outfit not provided'));
        // Add other routes requiring arguments here if any
          default:
          // This is a fallback for any route that is not explicitly defined in `routes`
          // and not handled by `onGenerateRoute`.
            print('Unknown route requested by onGenerateRoute: ${settings.name}');
            return MaterialPageRoute(
              builder: (context) => const AuthSelectionScreen(), // Default fallback
            );
        }
      },
      // onUnknownRoute is a last resort fallback if onGenerateRoute also fails to match
      onUnknownRoute: (settings) {
        print('Unknown route requested (onUnknownRoute): ${settings.name}');
        return MaterialPageRoute(
          builder: (context) => const AuthSelectionScreen(),
        );
      },
    );
  }
}