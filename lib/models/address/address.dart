import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  final double latitude;
  final double longitude;
  final String city;
  final String state;
  final String countryCode;
  final String country;
  final String formattedAddress;

  Address({
    this.latitude,
    this.longitude,
    this.city,
    this.state,
    this.countryCode,
    this.country,
    this.formattedAddress,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
