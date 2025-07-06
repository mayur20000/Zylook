import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../services/auth_service.dart';

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
  }
}