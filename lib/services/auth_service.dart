import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User> ensureSignedIn() async {
    User? user = _auth.currentUser;
    if (user == null) {
      final result = await _auth.signInAnonymously();
      user = result.user;
    }
    await _ensureUserDoc(user!);
    await _identifyWithAdapty(user);
    return user;
  }

  static Future<void> _ensureUserDoc(User user) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    await doc.set({
      'createdAt': FieldValue.serverTimestamp(),
      'tier': 'free',
      'credits': 0,
      'settings': {'weeklyReminders': true, 'videoCompleted': true},
    }, SetOptions(merge: true));
  }

  static Future<void> _identifyWithAdapty(User user) async {
    try {
      await Adapty().identify(user.uid);
    } catch (error, stackTrace) {
      debugPrint('Adapty identify başarısız: $error');
      debugPrint('$stackTrace');
    }
  }
}
