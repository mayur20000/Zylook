import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Keep this for direct Firebase Auth access
import 'dart:async'; // Import for StreamSubscription
// Removed: import 'package:zylook/main.dart'; // This import is not needed here

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  StreamSubscription? _userSubscription; // To listen to auth state changes

  AuthBloc(this.authService) : super(AuthInitial()) {
    // Listen to Firebase Auth state changes
    _userSubscription = authService.userChanges.listen((User? user) {
      if (user != null) {
        add(_AuthUserChanged(user.uid)); // Internal event for auth state changes
      } else {
        add(_AuthUserLoggedOut()); // Internal event for logout
      }
    });

    on<SendOtpEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await authService.sendOtp(event.phoneNumber);
      if (result['error'] != null) {
        emit(AuthError(result['error']));
      } else if (result['user'] != null) {
        // AuthSuccess will be emitted by _AuthUserChanged listener
      } else {
        emit(AuthOtpSent());
      }
    });

    on<VerifyOtpEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await authService.verifyOtp(event.otp);
      if (result['user'] != null) {
        // AuthSuccess will be emitted by _AuthUserChanged listener
      } else {
        emit(AuthError(result['error']));
      }
    });

    on<LoginWithEmailEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await authService.signInWithEmail(event.email, event.password);
      if (result['user'] != null) {
        // AuthSuccess will be emitted by _AuthUserChanged listener
      } else {
        emit(AuthError(result['error']));
      }
    });

    on<SignUpWithEmailEvent>((event, emit) async {
      if (event.password != event.confirmPassword) {
        emit(AuthError('Passwords do not match'));
        return;
      }
      emit(AuthLoading());
      final result = await authService.signUpWithEmail(event.email, event.password);
      if (result['user'] != null) {
        // AuthSuccess will be emitted by _AuthUserChanged listener
      } else {
        emit(AuthError(result['error']));
      }
    });

    // Handle internal event when Firebase Auth state changes to logged in
    on<_AuthUserChanged>((event, emit) {
      emit(AuthSuccess(event.userId));
    });

    // Handle internal event when Firebase Auth state changes to logged out
    on<_AuthUserLoggedOut>((event, emit) {
      emit(AuthInitial()); // Or a new AuthLoggedOut state if you prefer
    });

    on<CheckLoginStatusEvent>((event, emit) async {
      emit(AuthLoading());
      final isLoggedIn = await authService.isLoggedIn();
      if (isLoggedIn) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          emit(AuthSuccess(uid));
        } else {
          emit(AuthInitial()); // If isLoggedIn is true but UID is null, something is off
        }
      } else {
        emit(AuthInitial());
      }
    });

    on<AuthLogoutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authService.signOut();
        // The _userSubscription will catch the signOut and emit AuthInitial
      } catch (e) {
        emit(AuthError('Failed to logout: $e'));
      }
    });
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel(); // Cancel the subscription when BLoC is closed
    return super.close();
  }
}

// NEW: Internal Events for Auth Bloc
class _AuthUserChanged extends AuthEvent {
  final String userId;
  // Removed 'const' from the constructor
  _AuthUserChanged(this.userId);

  @override
  List<Object> get props => [userId];
}

class _AuthUserLoggedOut extends AuthEvent {}

// NEW: Public Logout Event
class AuthLogoutEvent extends AuthEvent {}