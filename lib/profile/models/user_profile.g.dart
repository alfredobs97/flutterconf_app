// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: strict_raw_type, require_trailing_commas, cast_nullable_to_non_nullable, lines_longer_than_80_chars

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String?,
  photoUrl: json['photoUrl'] as String?,
  jobRole: json['jobRole'] as String?,
  company: json['company'] as String?,
  linkedin: json['linkedin'] as String?,
  twitter: json['twitter'] as String?,
  youtube: json['youtube'] as String?,
  medium: json['medium'] as String?,
  workStatus:
      $enumDecodeNullable(_$WorkStatusEnumMap, json['workStatus']) ??
      WorkStatus.none,
  bio: json['bio'] as String?,
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'jobRole': instance.jobRole,
      'company': instance.company,
      'linkedin': instance.linkedin,
      'twitter': instance.twitter,
      'youtube': instance.youtube,
      'medium': instance.medium,
      'workStatus': _$WorkStatusEnumMap[instance.workStatus]!,
      'bio': instance.bio,
    };

const _$WorkStatusEnumMap = {
  WorkStatus.hiring: 'hiring',
  WorkStatus.openToWork: 'open_to_work',
  WorkStatus.busy: 'busy',
  WorkStatus.none: 'none',
};
