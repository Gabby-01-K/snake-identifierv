// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  Future<dynamic> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return result.user; // Success: return User
    } on FirebaseAuthException catch (e) { // Catch specific Firebase auth errors
      debugPrint("Firebase Auth Error: ${e.message}"); // USE debugPrint
      return e.message; // Failure: return error message string
    } catch (e) {
      debugPrint(e.toString()); // USE debugPrint
      return 'An unknown error occurred.'; // Failure: return generic string
    }
  }

  Future<dynamic> registerWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return result.user; // Success: return User
    } on FirebaseAuthException catch (e) { // Catch specific Firebase auth errors
      debugPrint("Firebase Auth Error: ${e.message}"); // USE debugPrint
      return e.message; // Failure: return error message string
    } catch (e) {
      debugPrint(e.toString()); // USE debugPrint
      return 'An unknown error occurred.'; // Failure: return generic string
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString()); // USE debugPrint
    }
  }
}