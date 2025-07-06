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
  bool isOtpSent = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(context.read<AuthService>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Phone Authentication')),
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
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isOtpSent) ...[
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
                  ] else ...[
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
                  ],
                ],
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
    super.dispose();
  }
}