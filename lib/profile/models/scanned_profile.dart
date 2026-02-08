import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'scanned_profile.g.dart';

@JsonSerializable()
class ScannedProfile extends Equatable {
  const ScannedProfile({
    required this.id,
    required this.displayName,
    required this.scannedAt,
  });

  factory ScannedProfile.fromJson(Map<String, dynamic> json) =>
      _$ScannedProfileFromJson(json);

  final String id;
  final String displayName;
  final DateTime scannedAt;

  Map<String, dynamic> toJson() => _$ScannedProfileToJson(this);

  @override
  List<Object?> get props => [id, displayName, scannedAt];
}
