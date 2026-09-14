import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Check if user is logged in
  static bool get isLoggedIn => _auth.currentUser != null;

  // Get current user ID
  static String? get currentUserId => _auth.currentUser?.uid;

  // Get current user email
  static String? get currentUserEmail => _auth.currentUser?.email;

  // Sign up with email & password
  static Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String city,
  }) async {
    try {
      // Create user in Firebase Auth
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        // Update display name
        await user.updateDisplayName(name);

        // Save user data to Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'phone': phone,
          'city': city,
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
          'profileComplete': true,
          'bio': '',
          'skills': [],
          'appliedJobs': 0,
          'completedSteps': 0,
          'xpPoints': 0,
        });

        // Send email verification
        await user.sendEmailVerification();

        return {
          'success': true,
          'message': 'Account created successfully!',
          'user': user,
        };
      }

      return {
        'success': false,
        'message': 'Failed to create account',
      };
    } on FirebaseAuthException catch (e) {
      return {
        'success': false,
        'message': _getErrorMessage(e.code),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  // Login with email & password
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return {
        'success': true,
        'message': 'Logged in successfully!',
        'user': userCredential.user,
      };
    } on FirebaseAuthException catch (e) {
      return {
        'success': false,
        'message': _getErrorMessage(e.code),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  // Reset password
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
        'message': 'Password reset email sent',
      };
    } on FirebaseAuthException catch (e) {
      return {
        'success': false,
        'message': _getErrorMessage(e.code),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  // Get user data from Firestore
  static Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateUserProfile({
    required String uid,
    required String name,
    required String phone,
    required String city,
    required String bio,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'name': name,
        'phone': phone,
        'city': city,
        'bio': bio,
        'updatedAt': DateTime.now(),
      });

      // Update Firebase Auth display name
      await _auth.currentUser?.updateDisplayName(name);

      return {
        'success': true,
        'message': 'Profile updated successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to update profile',
      };
    }
  }

  // Update user skills
  static Future<void> updateUserSkills(String uid, List<String> skills) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'skills': skills,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Increment applied jobs count
  static Future<void> incrementAppliedJobs(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'appliedJobs': FieldValue.increment(1),
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Update completed roadmap steps
  static Future<void> updateCompletedSteps(String uid, int steps) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'completedSteps': steps,
        'xpPoints': steps * 11,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  static Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Get error message from Firebase error code
  static String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'email-already-in-use':
        return 'Email already registered. Please login instead.';
      case 'invalid-email':
        return 'Email address is invalid.';
      case 'operation-not-allowed':
        return 'Email/password authentication is disabled.';
      case 'user-disabled':
        return 'User account has been disabled.';
      case 'user-not-found':
        return 'User account not found.';
      case 'wrong-password':
        return 'Password is incorrect.';
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'too-many-requests':
        return 'Too many login attempts. Try again later.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      default:
        return 'Authentication failed: $code';
    }
  }
}