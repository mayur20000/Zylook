import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:hugeicons/hugeicons.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return BlocProvider(
      create: (context) => AuthBloc(context.read<AuthService>()),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue, Colors.purple, Colors.white],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    print('Navigating to /home');
                    Navigator.pushReplacementNamed(context, '/home');
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state is AuthLoading;
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/animations/auth_header.json',
                          width: 200,
                          height: 200,
                          frameRate: FrameRate(30),
                        ),
                        const SizedBox(height: 20),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                TextField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(HugeIcons.strokeRoundedMail01),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  enabled: !isLoading,
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: passwordController,
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(HugeIcons.strokeRoundedLock),
                                  ),
                                  obscureText: true,
                                  enabled: !isLoading,
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: confirmPasswordController,
                                  decoration: const InputDecoration(
                                    labelText: 'Confirm Password',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(HugeIcons.strokeRoundedLock),
                                  ),
                                  obscureText: true,
                                  enabled: !isLoading,
                                ),
                                const SizedBox(height: 16),
                                isLoading
                                    ? Lottie.asset(
                                  'assets/animations/loading.json',
                                  width: 50,
                                  height: 50,
                                  frameRate: FrameRate(30),
                                )
                                    : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    minimumSize: const Size(double.infinity, 50),
                                  ),
                                  onPressed: () {
                                    final email = emailController.text.trim();
                                    final password = passwordController.text.trim();
                                    final confirmPassword = confirmPasswordController.text.trim();
                                    if (email.isNotEmpty && password.isNotEmpty) {
                                      print('Signing up with $email');
                                      context.read<AuthBloc>().add(
                                        SignUpWithEmailEvent(email, password, confirmPassword),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Enter valid email and password')),
                                      );
                                    }
                                  },
                                  child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            print('Navigating back to /auth_selection');
                            Navigator.pushReplacementNamed(context, '/auth_selection');
                          },
                          child: const Text('Back to Options', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}