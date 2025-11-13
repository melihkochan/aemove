import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final int credits;
  final String tier;
  final bool weeklyReminders;
  final bool videoCompleted;
  final String? subscriptionProductId;
  final String? subscriptionStatus;

  const UserProfile({
    required this.uid,
    required this.credits,
    required this.tier,
    required this.weeklyReminders,
    required this.videoCompleted,
    this.subscriptionProductId,
    this.subscriptionStatus,
  });

  factory UserProfile.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final settings = Map<String, dynamic>.from(
      (data['settings'] as Map<String, dynamic>? ?? <String, dynamic>{}),
    );
    final subscription = Map<String, dynamic>.from(
      (data['subscription'] as Map<String, dynamic>? ?? <String, dynamic>{}),
    );

    return UserProfile(
      uid: doc.id,
      credits: (data['credits'] is int)
          ? data['credits'] as int
          : (data['credits'] as num?)?.toInt() ?? 0,
      tier: data['tier'] as String? ?? 'free',
      weeklyReminders: settings['weeklyReminders'] as bool? ?? true,
      videoCompleted: settings['videoCompleted'] as bool? ?? true,
      subscriptionProductId: subscription['productId'] as String?,
      subscriptionStatus: subscription['status'] as String?,
    );
  }

  UserProfile copyWith({
    int? credits,
    String? tier,
    bool? weeklyReminders,
    bool? videoCompleted,
    String? subscriptionProductId,
    String? subscriptionStatus,
  }) {
    return UserProfile(
      uid: uid,
      credits: credits ?? this.credits,
      tier: tier ?? this.tier,
      weeklyReminders: weeklyReminders ?? this.weeklyReminders,
      videoCompleted: videoCompleted ?? this.videoCompleted,
      subscriptionProductId:
          subscriptionProductId ?? this.subscriptionProductId,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
    );
  }
}
