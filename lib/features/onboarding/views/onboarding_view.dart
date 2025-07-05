import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../models/onboarding_model.dart';
import '../widgets/page_transformer.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;
  List<OnboardingModel> _onboardingData = [];

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _buttonAnimationController, curve: Curves.easeInOut),
    );
    _loadOnboardingData();
  }

  Future<void> _loadOnboardingData() async {
    try {
      final String response = await DefaultAssetBundle.of(context).loadString('assets/data/onboarding_data.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        _onboardingData = data.map((json) => OnboardingModel.fromJson(json)).toList();
      });
    } catch (e) {
      print('Error loading onboarding data: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  void _onButtonTap() {
    _buttonAnimationController.forward().then((_) => _buttonAnimationController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    if (_onboardingData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state.isCompleted) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              PageTransformer(
                pageController: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  context.read<OnboardingBloc>().add(OnboardingNextEvent(index));
                },
                itemBuilder: (context, index, pageOffset) {
                  final data = _onboardingData[index];
                  return Container(
                    color: data.backgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          data.imagePath,
                          height: 200,
                          fit: BoxFit.cover,
                          onLoaded: (composition) {
                            // Optional: Handle Lottie animation loaded
                          },
                          errorBuilder: (context, error, stackTrace) {
                            print('Lottie load error: $error');
                            return const Icon(Icons.error, size: 100);
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          data.title,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data.description,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        if (index == 1) ...[
                          const SizedBox(height: 20),
                          DropdownButton<String>(
                            hint: const Text('Select Gender'),
                            value: state.gender,
                            onChanged: (value) {
                              context.read<OnboardingBloc>().add(
                                OnboardingPreferenceSelectedEvent(value!, state.style ?? 'Casual'),
                              );
                            },
                            items: ['Male', 'Female', 'Other']
                                .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
                                .toList(),
                          ),
                          DropdownButton<String>(
                            hint: const Text('Select Style'),
                            value: state.style,
                            onChanged: (value) {
                              context.read<OnboardingBloc>().add(
                                OnboardingPreferenceSelectedEvent(state.gender ?? 'Male', value!),
                              );
                            },
                            items: ['Casual', 'Formal', 'Trendi']
                                .map((style) => DropdownMenuItem(value: style, child: Text(style)))
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        _onButtonTap();
                        context.read<OnboardingBloc>().add(OnboardingCompleteEvent());
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black54,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    Row(
                      children: List.generate(_onboardingData.length, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: state.currentPage == index ? 12 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: state.currentPage == index ? Colors.white : Colors.white54,
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                    ScaleTransition(
                      scale: _buttonScaleAnimation,
                      child: ElevatedButton(
                        onPressed: () {
                          _onButtonTap();
                          if (state.currentPage < _onboardingData.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            context.read<OnboardingBloc>().add(OnboardingCompleteEvent());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black54,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          _onboardingData[state.currentPage].buttonText,
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}