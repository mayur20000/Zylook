import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    final completer = Completer<Map<String, dynamic>>();

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          final userCredential = await _auth.signInWithCredential(credential);
          if (!completer.isCompleted) {
            completer.complete({'user': userCredential.user, 'error': null});
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (!completer.isCompleted) {
            completer.complete({'user': null, 'error': _handleAuthError(e)});
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          if (!completer.isCompleted) {
            completer.complete({'user': null, 'error': null}); // Just indicate success of code sent
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          if (!completer.isCompleted) {
            completer.complete({'user': null, 'error': null});
          }
        },
      );

      return completer.future;
    } catch (e) {
      return {'user': null, 'error': 'An unexpected error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String otp) async {
    try {
      if (_verificationId == null) {
        return {'user': null, 'error': 'No verification ID available'};
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return {'user': userCredential.user, 'error': null};
    } catch (e) {
      return {'user': null, 'error': _handleAuthError(e)};
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-phone-number':
          return 'Invalid phone number format.';
        case 'invalid-verification-code':
          return 'Incorrect OTP entered.';
        case 'too-many-requests':
          return 'Too many requests. Try again later.';
        default:
          return 'Authentication error: ${error.message ?? error.toString()}';
      }
    }
    return 'An unexpected error occurred: $error';
  }
}
