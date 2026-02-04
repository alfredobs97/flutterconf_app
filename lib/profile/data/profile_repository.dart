import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterconf/profile/models/user_profile.dart';

class ProfileRepository {
  ProfileRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> updateProfile(UserProfile profile) async {
    await _firestore
        .collection('users')
        .doc(profile.id)
        .set(profile.toJson(), SetOptions(merge: true));
  }

  Future<UserProfile?> getProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists && doc.data() != null) {
      return UserProfile.fromJson(doc.data()!);
    }
    return null;
  }
}
