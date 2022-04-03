import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/api/api.dart';
import '../../../models/station/station.dart';
import '../../../authentication/authentication.dart';

part 'station_state.dart';

class StationCubit extends Cubit<StationState> {
  Station station;
  AuthenticationCubit authenticationCubit;

  final Map<String, bool> _sensors = {};
  Map<String, bool> get sensors => _sensors;

  StationCubit({this.station, this.authenticationCubit})
      : super(StationInitial()) {
    SENSORS.forEach(
      (key, value) =>
          _sensors[key] = station?.sensors?.contains(key) ?? false,
    );
  }

  Future<void> updateStation(Map<String, dynamic> data) async {
    emit(StationLoading());
    try {
      station = station.copyWith(
        name: data['name'],
        location: station.location
            .copyWith(formattedAddress: data['address']),
        sensors: _sensors.entries
            .where((sensor) => sensor.value)
            ?.map(
              (sensor) => sensor.key,
            )
            ?.toList(),
      );
      var jsonStation = station.toJson();

      if (station.id == null) {
        jsonStation.remove('_id');
        station = await MapAPI.createStation(jsonStation);
        authenticationCubit.userRepository.stations.add(station);
      } else {
        station = await MapAPI.updateStation(jsonStation);
      }
      emit(StationSuccess());
    } catch (e) {
      emit(StationFailed());
    }
  }

  Future<void> deleteStation() async {
    emit(StationLoading());
    try {
      await MapAPI.deleteStation(station.id);
      authenticationCubit.userRepository.stations.remove(station);
      emit(StationDeleted());
    } catch (e) {
      emit(StationFailed());
    }
  }

  void updateSensor(String sensor, bool value) {
    emit(StationLoading());
    _sensors[sensor] = value;
    emit(StationInitial());
  }
}
