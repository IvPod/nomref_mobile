import 'package:json_annotation/json_annotation.dart';

import '../location/location.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  @JsonKey(name: '_id')
  final String id;
  final String role;
  final String name;
  final String email;
  final String address;
  final Location location;
  final String image;
  final String token;

  const User({
    this.id,
    this.role,
    this.name,
    this.email,
    this.address,
    this.location,
    this.image,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String id,
    String role,
    String name,
    String email,
    String address,
    Location location,
    String image,
    String token,
  }) =>
      User(
        id: id ?? this.id,
        role: role ?? this.role,
        name: name ?? this.name,
        email: email ?? this.email,
        address: address ?? this.address,
        location: location ?? this.location,
        image: image ?? this.image,
        token: token ?? this.token,
      );
}
