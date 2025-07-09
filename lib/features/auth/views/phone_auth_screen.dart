import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:hugeicons/hugeicons.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../services/auth_service.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final phoneController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
  bool isOtpSent = false;

  @override
  void dispose() {
    phoneController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Helper to focus the next OTP field
  void _nextField(String value, int index) {
    if (value.length == 1 && index < otpControllers.length - 1) {
      FocusScope.of(context).nextFocus();
    }
    // If it's the last field and a digit is entered, unfocus the keyboard
    if (value.length == 1 && index == otpControllers.length - 1) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  if (state is AuthOtpSent) {
                    setState(() {
                      isOtpSent = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('OTP sent to your phone!')),
                    );
                  } else if (state is AuthSuccess) {
                    print('Phone authentication successful. Navigating to /main_navigation');
                    // *** FIX: Navigate to /main_navigation and clear auth stack ***
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/main_navigation',
                          (route) => false, // Clears all previous routes
                    );
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                    setState(() {
                      isOtpSent = false; // Reset if OTP verification fails
                    });
                  } else if (state is AuthLoading) {
                    // Optionally show a loading indicator here
                  }
                },
                builder: (context, state) {
                  return AbsorbPointer( // Disable interaction while loading
                    absorbing: state is AuthLoading,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Lottie.asset(
                            'assets/animations/onboarding2.json', // Ensure this asset exists
                            fit: BoxFit.contain,
                            frameRate: FrameRate(60),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Phone Verification',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Enter your phone number or the OTP sent to you.',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!isOtpSent) ...[
                                  TextField(
                                    controller: phoneController,
                                    decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                      hintText: '+1234567890',
                                      prefixIcon: const Icon(HugeIcons.strokeRoundedSmartPhone04, size: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                    ),
                                    keyboardType: TextInputType.phone,
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      minimumSize: const Size(double.infinity, 50),
                                    ),
                                    onPressed: () {
                                      final phoneNumber = phoneController.text.trim();
                                      if (phoneNumber.isNotEmpty) {
                                        print('Sending OTP to $phoneNumber');
                                        context.read<AuthBloc>().add(SendOtpEvent(phoneNumber));
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Enter a valid phone number')),
                                        );
                                      }
                                    },
                                    child: state is AuthLoading
                                        ? const CircularProgressIndicator(color: Colors.white)
                                        : const Text('Send OTP', style: TextStyle(fontSize: 16)),
                                  ),
                                ] else ...[
                                  const Text('Enter OTP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: List.generate(6, (index) => SizedBox(
                                      width: 40,
                                      child: TextField(
                                        controller: otpControllers[index],
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        maxLength: 1,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          counterText: "", // Hide the counter
                                        ),
                                        onChanged: (value) => _nextField(value, index),
                                      ),
                                    )),
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      minimumSize: const Size(double.infinity, 50),
                                    ),
                                    onPressed: () {
                                      final otp = otpControllers.map((e) => e.text).join();
                                      if (otp.length == 6) {
                                        print('Verifying OTP: $otp');
                                        context.read<AuthBloc>().add(VerifyOtpEvent(otp));
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Enter a valid 6-digit OTP')),
                                        );
                                      }
                                    },
                                    child: state is AuthLoading
                                        ? const CircularProgressIndicator(color: Colors.white)
                                        : const Text('Verify OTP', style: TextStyle(fontSize: 16)),
                                  ),
                                ],
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