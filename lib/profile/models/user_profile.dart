import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

enum WorkStatus {
  @JsonValue('hiring')
  hiring,
  @JsonValue('open_to_work')
  openToWork,
  @JsonValue('busy')
  busy,
  @JsonValue('none')
  none,
}

@JsonSerializable()
class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.jobRole,
    this.company,
    this.linkedin,
    this.twitter,
    this.youtube,
    this.medium,
    this.workStatus = WorkStatus.none,
    this.bio,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? jobRole;
  final String? company;
  final String? linkedin;
  final String? twitter;
  final String? youtube;
  final String? medium;
  final WorkStatus workStatus;
  final String? bio;

  UserProfile copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? jobRole,
    String? company,
    String? linkedin,
    String? twitter,
    String? youtube,
    String? medium,
    WorkStatus? workStatus,
    String? bio,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      jobRole: jobRole ?? this.jobRole,
      company: company ?? this.company,
      linkedin: linkedin ?? this.linkedin,
      twitter: twitter ?? this.twitter,
      youtube: youtube ?? this.youtube,
      medium: medium ?? this.medium,
      workStatus: workStatus ?? this.workStatus,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    photoUrl,
    jobRole,
    company,
    linkedin,
    twitter,
    youtube,
    medium,
    workStatus,
    bio,
  ];
}
