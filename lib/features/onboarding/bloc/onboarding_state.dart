class OnboardingState {
  final int currentPage;
  final String? gender;
  final String? style;
  final bool isCompleted;

  OnboardingState({
    this.currentPage = 0,
    this.gender,
    this.style,
    this.isCompleted = false,
  });

  OnboardingState copyWith({
    int? currentPage,
    String? gender,
    String? style,
    bool? isCompleted,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      gender: gender ?? this.gender,
      style: style ?? this.style,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}