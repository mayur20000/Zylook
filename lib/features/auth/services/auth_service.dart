// lib/features/auth/services/auth_service.dart

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Add Firestore instance
  String? _verificationId;

  // Stream to listen to Firebase Auth state changes
  Stream<User?> get userChanges => _auth.authStateChanges();

  // Send OTP to phone number
  Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    final completer = Completer<Map<String, dynamic>>();

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          final userCredential = await _auth.signInWithCredential(credential);
          await _storeUserId(userCredential.user?.uid);
          // Save user profile on successful phone verification
          if (userCredential.user != null) {
            await _saveUserProfile(userCredential.user!);
          }
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
      await _storeUserId(userCredential.user?.uid);
      // Save user profile on successful OTP verification
      if (userCredential.user != null) {
        await _saveUserProfile(userCredential.user!);
      }
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
      await _storeUserId(credential.user?.uid);
      // Save user profile on successful email login
      if (credential.user != null) {
        await _saveUserProfile(credential.user!);
      }
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
      await _storeUserId(credential.user?.uid);
      // Save user profile on successful email signup
      if (credential.user != null) {
        await _saveUserProfile(credential.user!);
      }
      return {'user': credential.user, 'error': null};
    } catch (e) {
      return {'user': null, 'error': _handleAuthError(e)};
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id'); // Clear local stored UID
    await _auth.signOut(); // Sign out from Firebase
  }

  // Check if user is logged in (using SharedPreferences and FirebaseAuth)
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    // Check if Firebase has a current user AND if the stored UID matches
    return _auth.currentUser != null && userId != null && userId == _auth.currentUser!.uid;
  }

  // Store user ID in SharedPreferences
  Future<void> _storeUserId(String? uid) async {
    if (uid != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', uid);
    }
  }

  // NEW: Save/Update user profile in Firestore
  Future<void> _saveUserProfile(User user) async {
    if (user.uid.isEmpty) return; // Ensure UID is not empty

    // Check if the document exists to decide whether to set 'createdAt'
    // This is optional if you always want 'lastLogin' to be updated and 'createdAt' to be set only once.
    // Given SetOptions(merge: true), 'createdAt' will only be set if it doesn't exist.
    await _firestore.collection('users').doc(user.uid).set({
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'displayName': user.displayName, // Will be null for new email users unless updated later
      'photoURL': user.photoURL, // Will be null unless updated later
      'lastLogin': FieldValue.serverTimestamp(),
      // Corrected: Use FieldValue.serverTimestamp() directly for createdAt.
      // With merge: true, this field will only be set on the initial creation of the document.
      'createdAt': FieldValue.serverTimestamp(),
      // You can add more fields like 'firstName', 'lastName', 'address', etc.
    }, SetOptions(merge: true));
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