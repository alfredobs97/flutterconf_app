import 'dart:async';
import 'dart:convert';

import 'package:flutterconf/profile/models/scanned_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScannedProfilesRepository {
  ScannedProfilesRepository({
    SharedPreferences? sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  SharedPreferences? _sharedPreferences;

  // Use a random string as key
  static const _dataKey = 'x8k29d1m4n5p7q3z';

  Future<void> _init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  Future<List<ScannedProfile>> getScannedProfiles() async {
    await _init();

    try {
      final jsonString = _sharedPreferences?.getString(_dataKey);
      if (jsonString == null) return [];

      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((e) => ScannedProfile.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> addScannedProfile(ScannedProfile profile) async {
    await _init();
    final profiles = await getScannedProfiles();

    final index = profiles.indexWhere((p) => p.id == profile.id);

    if (index >= 0) {
      profiles.removeAt(index);
    }

    profiles.insert(0, profile);

    await _saveProfiles(profiles);

    return index < 0;
  }

  Future<void> removeScannedProfile(String userId) async {
    await _init();
    final profiles = await getScannedProfiles();
    profiles.removeWhere((p) => p.id == userId);
    await _saveProfiles(profiles);
  }

  Future<void> _saveProfiles(List<ScannedProfile> profiles) async {
    final jsonString = jsonEncode(profiles.map((e) => e.toJson()).toList());
    await _sharedPreferences?.setString(_dataKey, jsonString);
  }
}
