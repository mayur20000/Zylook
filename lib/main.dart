// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Auth Feature Imports
import 'package:zylook/features/auth/services/auth_service.dart';
import 'package:zylook/features/auth/views/auth_selection_screen.dart';
import 'package:zylook/features/auth/views/phone_auth_screen.dart';
import 'package:zylook/features/auth/views/login_screen.dart';
import 'package:zylook/features/auth/views/signup_screen.dart';
import 'package:zylook/features/auth/bloc/auth_bloc.dart';
import 'package:zylook/features/auth/bloc/auth_state.dart';

// Onboarding Feature Import
import 'package:zylook/features/onboarding/views/onboarding_screen.dart';

// Home Feature Imports
import 'package:zylook/features/home/views/outfit_detail_screen.dart'; // Keep this for direct pushes
import 'package:zylook/features/home/bloc/home_bloc.dart';
import 'package:zylook/features/home/services/home_service.dart';
import 'package:zylook/features/home/models/outfit_model.dart';

// Cart Feature Imports
import 'package:zylook/features/cart/views/cart_screen.dart';
import 'package:zylook/features/cart/bloc/cart_bloc.dart';
import 'package:zylook/features/cart/services/cart_service.dart';
import 'package:zylook/features/cart/bloc/cart_event.dart';

// NEW: Main Navigation Screen Import
import 'package:zylook/main_navigation_screen.dart'; // Import the new screen

import 'package:zylook/firebase_options.dart';

import 'features/auth/bloc/auth_event.dart';
import 'features/home/bloc/home_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final bool onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(context.read<AuthService>()),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(homeService: HomeService())..add(LoadOutfitsEvent()), // Dispatch on creation
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(cartService: CartService())..add(LoadCartItems()),
        ),
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
          backgroundColor: Color(0xFFF0F0F0),
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/auth_selection',
                  (route) => false,
            );
          } else if (state is AuthSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/main_navigation', // Navigate to the new main navigation screen
                  (route) => false,
            );
          }
        },
        child: _AuthChecker(onboardingCompleted: onboardingCompleted),
      ),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/auth_selection': (context) => const AuthSelectionScreen(),
        '/phone_auth': (context) => const PhoneAuthScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/main_navigation': (context) => const MainNavigationScreen(), // NEW route for the main navigation
        '/profile': (context) => const Center(child: Text('Profile Screen')),
        '/settings': (context) => const Center(child: Text('Settings Screen')),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/outfit_detail':
            final args = settings.arguments;
            if (args is Outfit) {
              return MaterialPageRoute(
                builder: (context) => OutfitDetailScreen(outfit: args),
              );
            }
            return MaterialPageRoute(builder: (context) => const Text('Error: Outfit not provided'));
          default:
            print('Unknown route requested by onGenerateRoute: ${settings.name}');
            return MaterialPageRoute(
              builder: (context) => const AuthSelectionScreen(),
            );
        }
      },
      onUnknownRoute: (settings) {
        print('Unknown route requested (onUnknownRoute): ${settings.name}');
        return MaterialPageRoute(
          builder: (context) => const AuthSelectionScreen(),
        );
      },
    );
  }
}

class _AuthChecker extends StatefulWidget {
  final bool onboardingCompleted;
  const _AuthChecker({Key? key, required this.onboardingCompleted}) : super(key: key);

  @override
  State<_AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<_AuthChecker> {
  @override
  void initState() {
    super.initState();
    if (widget.onboardingCompleted) {
      context.read<AuthBloc>().add(CheckLoginStatusEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.onboardingCompleted) {
      return const OnboardingScreen();
    }

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is AuthSuccess) {
          return const MainNavigationScreen(); // Go to MainNavigationScreen if logged in
        } else if (state is AuthInitial || state is AuthError) {
          return const AuthSelectionScreen();
        }
        return const Scaffold(
          body: Center(child: Text('Initializing...')),
        );
      },
    );
  }
}