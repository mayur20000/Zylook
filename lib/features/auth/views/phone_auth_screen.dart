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
                  if (state is AuthSuccess) {
                    print('Navigating to /home');
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
                                if (!isOtpSent) ...[
                                  TextField(
                                    controller: phoneController,
                                    decoration: const InputDecoration(
                                      labelText: 'Phone Number (e.g., +91xxxxxxxxxx)',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(HugeIcons.strokeRoundedAiPhone01),
                                    ),
                                    keyboardType: TextInputType.phone,
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
                                      final phone = phoneController.text.trim();
                                      if (phone.isNotEmpty) {
                                        print('Sending OTP for $phone');
                                        context.read<AuthBloc>().add(SendOtpEvent(phone));
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Enter a valid phone number')),
                                        );
                                      }
                                    },
                                    child: const Text('Send OTP', style: TextStyle(fontSize: 16)),
                                  ),
                                ] else ...[
                                  const Text(
                                    'Enter OTP',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: List.generate(6, (index) {
                                      return SizedBox(
                                        width: 40,
                                        child: TextField(
                                          controller: otpControllers[index],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            counterText: '',
                                          ),
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          maxLength: 1,
                                          enabled: !isLoading,
                                          onChanged: (value) {
                                            if (value.isNotEmpty && index < 5) {
                                              FocusScope.of(context).nextFocus();
                                            } else if (value.isEmpty && index > 0) {
                                              FocusScope.of(context).previousFocus();
                                            }
                                          },
                                        ),
                                      );
                                    }),
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
                                      final otp = otpControllers.map((c) => c.text).join();
                                      if (otp.length == 6) {
                                        print('Verifying OTP: $otp');
                                        context.read<AuthBloc>().add(VerifyOtpEvent(otp));
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Enter a valid 6-digit OTP')),
                                        );
                                      }
                                    },
                                    child: const Text('Verify OTP', style: TextStyle(fontSize: 16)),
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