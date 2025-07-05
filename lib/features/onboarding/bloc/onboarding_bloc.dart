import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';
import '../services/onboarding_service.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final OnboardingService onboardingService;

  OnboardingBloc(this.onboardingService) : super(OnboardingState()) {
    on<OnboardingNextEvent>((event, emit) {
      emit(state.copyWith(currentPage: event.currentPage));
    });

    on<OnboardingPreferenceSelectedEvent>((event, emit) {
      emit(state.copyWith(gender: event.gender, style: event.style));
    });

    on<OnboardingCompleteEvent>((event, emit) async {
      await onboardingService.setOnboardingCompleted();
      emit(state.copyWith(isCompleted: true));
    });
  }
}