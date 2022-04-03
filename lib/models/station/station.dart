import 'package:json_annotation/json_annotation.dart';

import '../location/location.dart';

part 'station.g.dart';

const SENSORS = {
  'AirTemperature': 'Температура',
  'Humidity': 'Влажность',
  'AirPressure': 'Атм.давление',
  'WindSpeed': 'Скорость ветра',
  'WindDirection': 'Направление',
};

@JsonSerializable(explicitToJson: true)
class Station {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  @JsonKey(name: 'user')
  final String userId;
  final Location location;
  final List<String> sensors;
  final DateTime createdAt;

  Station({
    this.id,
    this.name,
    this.userId,
    this.location,
    this.sensors,
    this.createdAt,
  });

  factory Station.fromJson(Map<String, dynamic> json) =>
      _$StationFromJson(json);
  Map<String, dynamic> toJson() => _$StationToJson(this);

  Station copyWith({
    String id,
    String name,
    String userId,
    Location location,
    List<String> sensors,
    DateTime createAt,
  }) =>
      Station(
        id: id ?? this.id,
        name: name ?? this.name,
        userId: userId ?? this.userId,
        location: location ?? this.location,
        sensors: sensors ?? this.sensors,
        createdAt: createdAt ?? this.createdAt,
      );
}
