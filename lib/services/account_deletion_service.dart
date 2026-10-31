import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Calls the trusted backend. The client never supplies a UID or performs
/// broad Firestore deletion itself.
class AccountDeletionService {
  AccountDeletionService._();

  static final FirebaseFunctions _functions =
      FirebaseFunctions.instanceFor(region: 'asia-south1');

  static Future<void> deleteCurrentAccount() async {
    if (FirebaseAuth.instance.currentUser == null) {
      throw StateError('No signed-in user was found.');
    }

    try {
      final callable = _functions.httpsCallable('deleteMyAccount');
      final result = await callable.call();
      if (result.data is! Map || result.data['success'] != true) {
        throw StateError('The server did not confirm account deletion.');
      }

      // Remove only known Career Guide local progress keys; preserve
      // unrelated app preferences.
      final prefs = await SharedPreferences.getInstance();
      for (var i = 1; i <= 15; i++) {
        await prefs.remove('rmap_$i');
        await prefs.remove('phase_v2_$i');
      }
      await prefs.remove('streak_days');
      await FirebaseAuth.instance.signOut();
    } on FirebaseFunctionsException catch (e) {
      if (e.code == 'failed-precondition' &&
          (e.message ?? '').contains('RECENT_LOGIN_REQUIRED')) {
        throw StateError(
          'For security, sign out and sign in again, then retry account deletion.',
        );
      }
      rethrow;
    }
  }
}
