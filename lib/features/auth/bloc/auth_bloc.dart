
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<SendOtpEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await authService.sendOtp(event.phoneNumber);
      if (result['error'] != null) {
        emit(AuthError(result['error']));
      } else if (result['user'] != null) {
        emit(AuthSuccess(result['user'].uid));
      } else {
        emit(AuthOtpSent());
      }
    });

    on<VerifyOtpEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await authService.verifyOtp(event.otp);
      if (result['user'] != null) {
        emit(AuthSuccess(result['user'].uid));
      } else {
        emit(AuthError(result['error']));
      }
    });

    on<LoginWithEmailEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await authService.signInWithEmail(event.email, event.password);
      if (result['user'] != null) {
        emit(AuthSuccess(result['user'].uid));
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
        emit(AuthSuccess(result['user'].uid));
      } else {
        emit(AuthError(result['error']));
      }
    });

    on<CheckLoginStatusEvent>((event, emit) async {
      emit(AuthLoading());
      final isLoggedIn = await authService.isLoggedIn();
      if (isLoggedIn) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          emit(AuthSuccess(uid));
        } else {
          emit(AuthError('No user ID found'));
        }
      } else {
        emit(AuthInitial());
      }
    });
  }
}
