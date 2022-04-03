// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Station _$StationFromJson(Map<String, dynamic> json) {
  return Station(
    id: json['_id'] as String,
    name: json['name'] as String,
    userId: json['user'] as String,
    location: json['location'] == null
        ? null
        : Location.fromJson(json['location'] as Map<String, dynamic>),
    sensors: (json['sensors'] as List)?.map((e) => e as String)?.toList(),
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
  );
}

Map<String, dynamic> _$StationToJson(Station instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'user': instance.userId,
      'location': instance.location?.toJson(),
      'sensors': instance.sensors,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
