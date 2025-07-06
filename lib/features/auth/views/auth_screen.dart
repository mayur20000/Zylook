import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isOtpSent = false;
  bool isPhoneAuth = true; // Toggle between phone and email auth

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(context.read<AuthService>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Authentication')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                Navigator.pushReplacementNamed(context, '/home');
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is AuthOtpSent) {
                setState(() {
                  isOtpSent = true;
                });
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Toggle between phone and email auth
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChoiceChip(
                          label: const Text('Phone'),
                          selected: isPhoneAuth,
                          onSelected: (selected) {
                            if (selected && !isLoading) {
                              setState(() {
                                isPhoneAuth = true;
                                isOtpSent = false;
                                phoneController.clear();
                                otpController.clear();
                                emailController.clear();
                                passwordController.clear();
                                confirmPasswordController.clear();
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Email'),
                          selected: !isPhoneAuth,
                          onSelected: (selected) {
                            if (selected && !isLoading) {
                              setState(() {
                                isPhoneAuth = false;
                                isOtpSent = false;
                                phoneController.clear();
                                otpController.clear();
                                emailController.clear();
                                passwordController.clear();
                                confirmPasswordController.clear();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (isPhoneAuth && !isOtpSent) ...[
                      TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number (e.g., +91xxxxxxxxxx)',
                        ),
                        keyboardType: TextInputType.phone,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                          final phone = phoneController.text.trim();
                          if (phone.isNotEmpty) {
                            context.read<AuthBloc>().add(SendOtpEvent(phone));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Enter a valid phone number')),
                            );
                          }
                        },
                        child: const Text('Send OTP'),
                      ),
                    ] else if (isPhoneAuth && isOtpSent) ...[
                      TextField(
                        controller: otpController,
                        decoration: const InputDecoration(labelText: 'Enter OTP'),
                        keyboardType: TextInputType.number,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                          final otp = otpController.text.trim();
                          if (otp.isNotEmpty) {
                            context.read<AuthBloc>().add(VerifyOtpEvent(otp));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Enter a valid OTP')),
                            );
                          }
                        },
                        child: const Text('Verify OTP'),
                      ),
                    ] else if (!isPhoneAuth) ...[
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: confirmPasswordController,
                        decoration: const InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();
                          final confirmPassword = confirmPasswordController.text.trim();
                          if (email.isNotEmpty && password.isNotEmpty) {
                            context.read<AuthBloc>().add(
                              SignUpWithEmailEvent(email, password, confirmPassword),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Enter valid email and password')),
                            );
                          }
                        },
                        child: const Text('Sign Up'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();
                          if (email.isNotEmpty && password.isNotEmpty) {
                            context.read<AuthBloc>().add(
                              LoginWithEmailEvent(email, password),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Enter valid email and password')),
                            );
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}