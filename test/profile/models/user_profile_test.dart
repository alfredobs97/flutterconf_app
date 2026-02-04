import 'package:flutter_test/flutter_test.dart';
import 'package:flutterconf/profile/models/user_profile.dart';

void main() {
  group('UserProfile', () {
    const userProfile = UserProfile(
      id: '1',
      email: 'test@example.com',
      workStatus: WorkStatus.hiring,
    );

    test('supports value comparisons', () {
      expect(
        userProfile,
        const UserProfile(
          id: '1',
          email: 'test@example.com',
          workStatus: WorkStatus.hiring,
        ),
      );
    });

    test('toJson returns correct map', () {
      expect(userProfile.toJson(), {
        'id': '1',
        'email': 'test@example.com',
        'displayName': null,
        'photoUrl': null,
        'jobRole': null,
        'company': null,
        'linkedin': null,
        'twitter': null,
        'youtube': null,
        'medium': null,
        'workStatus': 'hiring',
        'bio': null,
      });
    });

    test('fromJson returns correct object', () {
      expect(
        UserProfile.fromJson(const {
          'id': '1',
          'email': 'test@example.com',
          'workStatus': 'hiring',
        }),
        userProfile,
      );
    });
  });
}
