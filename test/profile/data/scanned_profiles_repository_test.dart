import 'package:flutter_test/flutter_test.dart';
import 'package:flutterconf/profile/data/scanned_profiles_repository.dart';
import 'package:flutterconf/profile/models/scanned_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ScannedProfilesRepository', () {
    late ScannedProfilesRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      repository = ScannedProfilesRepository();
    });

    test('starts empty', () async {
      expect(await repository.getScannedProfiles(), isEmpty);
    });

    test('addScannedProfile adds a profile and returns true for new', () async {
      final profile = ScannedProfile(
        id: '1',
        displayName: 'Test User',
        scannedAt: DateTime.now(),
      );
      final isNew = await repository.addScannedProfile(profile);

      expect(isNew, isTrue);
      final profiles = await repository.getScannedProfiles();
      expect(profiles.length, 1);
      expect(profiles.first.id, profile.id);
    });

    test(
      'addScannedProfile updates existing profile and returns false',
      () async {
        final profile1 = ScannedProfile(
          id: '1',
          displayName: 'Test User',
          scannedAt: DateTime.now().subtract(const Duration(minutes: 5)),
        );
        await repository.addScannedProfile(profile1);

        final profile1Updated = ScannedProfile(
          id: '1',
          displayName: 'Test User Updated',
          scannedAt: DateTime.now(),
        );
        final isNew = await repository.addScannedProfile(profile1Updated);

        expect(isNew, isFalse);
        final profiles = await repository.getScannedProfiles();
        expect(profiles.length, 1);
        expect(profiles.first.displayName, 'Test User Updated');
      },
    );

    test('removeScannedProfile removes a profile', () async {
      final profile = ScannedProfile(
        id: '1',
        displayName: 'Test User',
        scannedAt: DateTime.now(),
      );
      await repository.addScannedProfile(profile);
      await repository.removeScannedProfile('1');
      expect(await repository.getScannedProfiles(), isEmpty);
    });
  });
}
