import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/api/api.dart';
import '../../../models/address/address.dart';
import '../../../models/station/station.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  var _zoom = 8.0;
  var _radius = 60.0;
  var _center = <double>[];
  var _isRadarActive = false;
  var _isAddStationActive = false;

  var _stationAddress;
  var _stations = <Station>[];

  double get zoom => _zoom;
  double get radius => _radius;
  List<double> get center => _center;
  bool get isRadarActive => _isRadarActive;
  bool get isAddStationActive => _isAddStationActive;

  List<Station> get stations => _stations;
  Address get stationAddress => _stationAddress;

  HomeCubit() : super(HomeInitial());

  Future<void> getStations({Map<String, dynamic> data}) async {
    emit(HomeLoading());
    try {
      _stations = await (data != null
          ? MapAPI.getStationsInBox(data)
          : MapAPI.getStations());
      emit(HomeInitial());
    } catch (error) {
      emit(HomeFailed());
    }
  }

  void setAddStationToActive({List<double> center}) {
    _center = center;
    _stations = <Station>[];
    _isAddStationActive = true;
    emit(HomeAddStationActive());
    getLocationByCoords();
  }

  void setAddStationToNotActive() {
    _center = <double>[];
    _stationAddress = null;
    _isAddStationActive = false;
    emit(HomeInitial());
  }

  Future<void> getLocationByCoords() async {
    _stationAddress = null;
    emit(HomeLoading());
    _stationAddress = await MapAPI.getLocationByCoords(center);
    emit(HomeAddStationActive());
  }

  Future<void> getStationsInRadius() async {
    emit(HomeLoading());
    _stations = await MapAPI.getStationsInRadius({
      'lat': _center[0],
      'lng': _center[1],
      'radius': _radius,
    });
    emit(HomeRadarActive());
  }

  void setCenter({List<double> center}) {
    _center = center;
    if (_isRadarActive) {
      getStationsInRadius();
    } else if (_isAddStationActive) {
      getLocationByCoords();
    }
  }

  void setRadarStateToActive({List<double> center}) {
    _center = center;
    _isRadarActive = true;
    _zoom = getZoomLevel(_radius * 1000);
    getStationsInRadius();
  }

  void setRadarStateToNotActive() {
    _radius = 60.0;
    _center = <double>[];
    _stations = <Station>[];
    _isRadarActive = false;
    emit(HomeInitial());
  }

  num getZoomLevel(double radius) {
    var zoomLevel;
    if (radius != null) {
      num newRadius = radius + radius / 2;
      num scale = newRadius / 300;
      zoomLevel = 16 - log(scale) / log(2);
    }
    return zoomLevel;
  }

  void setRadius(double radius) {
    emit(HomeLoading());
    _radius = radius;
    if (_radius > 0) _zoom = getZoomLevel(radius * 1000);
    emit(HomeRadarActive());
  }
}
