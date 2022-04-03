import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  final String type;
  final String formattedAddress;
  final List<double> coordinates;

  Location({this.type, this.formattedAddress, this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  Location copyWith({
    String type,
    String formattedAddress,
    List<double> coordinates,
  }) =>
      Location(
        type: type ?? this.type,
        formattedAddress: formattedAddress ?? this.formattedAddress,
        coordinates: coordinates ?? this.coordinates,
      );
}
