// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: strict_raw_type, require_trailing_commas, cast_nullable_to_non_nullable, lines_longer_than_80_chars

part of 'scanned_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScannedProfile _$ScannedProfileFromJson(Map<String, dynamic> json) =>
    ScannedProfile(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      scannedAt: DateTime.parse(json['scannedAt'] as String),
    );

Map<String, dynamic> _$ScannedProfileToJson(ScannedProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'scannedAt': instance.scannedAt.toIso8601String(),
    };
