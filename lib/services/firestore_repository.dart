import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/pricing_models.dart';
import '../models/user_profile.dart';
import '../models/video_entry.dart';

class FirestoreRepository {
  FirestoreRepository._();

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Stream<UserProfile> userProfileStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snapshot, _) => snapshot.data() ?? {},
          toFirestore: (data, _) => data,
        )
        .snapshots()
        .map(UserProfile.fromDoc);
  }

  static Future<PricingConfig> loadPricingConfig() async {
    final doc = await _db
        .collection('config')
        .doc('pricing')
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snapshot, _) => snapshot.data() ?? {},
          toFirestore: (data, _) => data,
        )
        .get();

    if (!doc.exists) {
      return PricingConfig.defaults();
    }

    return PricingConfig.fromDoc(doc);
  }

  static Future<void> updateUserSetting(String uid, String key, bool value) {
    return _db.collection('users').doc(uid).set({
      'settings': {key: value},
    }, SetOptions(merge: true));
  }

  static Stream<List<VideoEntry>> videosStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('videos')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(VideoEntry.fromDoc).toList());
  }
}
