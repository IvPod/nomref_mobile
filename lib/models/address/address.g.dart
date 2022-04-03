// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
    city: json['city'] as String,
    state: json['state'] as String,
    countryCode: json['countryCode'] as String,
    country: json['country'] as String,
    formattedAddress: json['formattedAddress'] as String,
  );
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'city': instance.city,
      'state': instance.state,
      'countryCode': instance.countryCode,
      'country': instance.country,
      'formattedAddress': instance.formattedAddress,
    };
