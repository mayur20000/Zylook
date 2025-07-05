abstract class OnboardingEvent {}

class OnboardingNextEvent extends OnboardingEvent {
  final int currentPage;
  OnboardingNextEvent(this.currentPage);
}

class OnboardingCompleteEvent extends OnboardingEvent {}

class OnboardingPreferenceSelectedEvent extends OnboardingEvent {
  final String gender;
  final String style;
  OnboardingPreferenceSelectedEvent(this.gender, this.style);
}