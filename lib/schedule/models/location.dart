import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location extends Equatable {
  const Location({
    required this.name,
    required this.coordinates,
    this.mapUrl,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  final String name;
  final (double latitude, double longitude) coordinates;
  final String? mapUrl;

  @override
  List<Object?> get props => [name, coordinates, mapUrl];
}
