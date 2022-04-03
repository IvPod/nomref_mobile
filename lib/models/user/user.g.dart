// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['_id'] as String,
    role: json['role'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    address: json['address'] as String,
    location: json['location'] == null
        ? null
        : Location.fromJson(json['location'] as Map<String, dynamic>),
    image: json['image'] as String,
    token: json['token'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      'role': instance.role,
      'name': instance.name,
      'email': instance.email,
      'address': instance.address,
      'location': instance.location?.toJson(),
      'image': instance.image,
      'token': instance.token,
    };
