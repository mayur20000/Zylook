import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  // Send OTP to phone number
  Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    final completer = Completer<Map<String, dynamic>>();

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          final userCredential = await _auth.signInWithCredential(credential);
          completer.complete({'user': userCredential.user, 'error': null});
        },
        verificationFailed: (FirebaseAuthException e) {
          completer.complete({'user': null, 'error': _handleAuthError(e)});
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          completer.complete({'user': null, 'error': null});
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

  // Verify OTP entered by the user
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

  // Sign in with email and password
  Future<Map<String, dynamic>> signInWithEmail(String email, String password) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {'user': credential.user, 'error': null};
    } catch (e) {
      return {'user': null, 'error': _handleAuthError(e)};
    }
  }

  // Sign up with email and password
  Future<Map<String, dynamic>> signUpWithEmail(String email, String password) async {
    try {
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {'user': credential.user, 'error': null};
    } catch (e) {
      return {'user': null, 'error': _handleAuthError(e)};
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Map FirebaseAuthException to user-friendly messages
  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-phone-number':
          return 'Invalid phone number format.';
        case 'invalid-verification-code':
          return 'Incorrect OTP entered.';
        case 'too-many-requests':
          return 'Too many requests. Try again later.';
        case 'invalid-email':
          return 'Invalid email address.';
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'email-already-in-use':
          return 'Email is already registered.';
        case 'weak-password':
          return 'Password is too weak.';
        default:
          return 'Authentication error: ${error.message ?? error.toString()}';
      }
    }
    return 'An unexpected error occurred: $error';
  }
}
