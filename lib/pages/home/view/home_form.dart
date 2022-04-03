import 'dart:async';

import 'package:flutter/material.dart';

import 'package:latlong/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:nomref_mob/pages/station_view/station_view.dart';

import 'package:nomref_mob/services/api/api.dart';

import '../home.dart';

class HomeForm extends StatefulWidget {
  @override
  _HomeFormState createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  Timer _timer;
  HomeCubit _homeCubit;
  final markers = <Marker>[];
  var _stationMarker = Marker();
  var _circleMarker = CircleMarker();
  MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _homeCubit = BlocProvider.of<HomeCubit>(context);
    _mapController.onReady.then((_) async {
      await Future.delayed(Duration(microseconds: 1));
      _homeCubit.getStations(
          data: getMapBounds(_mapController.bounds));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      cubit: _homeCubit,
      listener: (context, state) {
        if (state is HomeInitial) {
          _updateStationMarkers();
          _stationMarker = Marker();
          _circleMarker = CircleMarker();
        }
        if (state is HomeAddStationActive) {
          _updateStationMarkers();
          _stationMarker = Marker(
            point: LatLng(_homeCubit.center[0], _homeCubit.center[1]),
            builder: (context) =>
                Icon(Icons.location_on, color: Colors.blue),
          );
        }
        if (state is HomeRadarActive) {
          _updateStationMarkers();
          _mapController.move(
            LatLng(
              _homeCubit.center[0],
              _homeCubit.center[1],
            ),
            _homeCubit.zoom,
          );
          _circleMarker = CircleMarker(
            point: LatLng(_mapController.center.latitude,
                _mapController.center.longitude),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderColor: Theme.of(context).colorScheme.primary,
            radius: _homeCubit.radius * 1000,
            useRadiusInMeter: true,
            borderStrokeWidth: 3,
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            buildMap(),
            if (!_homeCubit.isRadarActive &&
                !_homeCubit.isAddStationActive) ...[
              ButtonsLayer(mapController: _mapController),
            ],
            if (_homeCubit.isRadarActive) ...[
              RadarBottomSheet(mapController: _mapController),
            ],
            if (_homeCubit.isAddStationActive) ...[
              AddStationButtonLayer(mapController: _mapController),
            ],
          ],
        );
      },
    );
  }

  Widget buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: LatLng(59.889651, 29.87631),
        zoom: 9.0,
        onTap: (point) => _handleOnTap(point),
        onPositionChanged: (position, hasGesture) =>
            _handleOnPositionChanged(position, hasGesture),
      ),
      layers: [
        TileLayerOptions(
          urlTemplate:
              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        CircleLayerOptions(circles: [_circleMarker]),
        MarkerLayerOptions(
          markers: [
            ...markers,
            _stationMarker,
          ],
        ),
      ],
    );
  }

  void _updateStationMarkers() {
    markers.clear();
    _homeCubit?.stations?.asMap()?.forEach((index, station) {
      markers.add(StationMarker(
        context,
        station: station,
        onTap: () => Navigator.of(context)
            .pushNamed(StationViewPage.routeName, arguments: station),
      ));
    });
  }

  void _handleOnPositionChanged(
      MapPosition mapPosition, bool hasGesture) {
    if (hasGesture) {
      _timer?.cancel();
      _timer = Timer(Duration(milliseconds: 250), () {
        if (_homeCubit.isRadarActive)
          _homeCubit.setCenter(center: [
            mapPosition.center.latitude,
            mapPosition.center.longitude,
          ]);
        else if (!_homeCubit.isAddStationActive)
          _homeCubit.getStations(
              data: getMapBounds(mapPosition.bounds));
      });
    }
  }

  void _handleOnTap(LatLng point) {
    if (_homeCubit.isAddStationActive) {
      _homeCubit.setCenter(center: [point.latitude, point.longitude]);
      _stationMarker = Marker(
        point: LatLng(_homeCubit.center[0], _homeCubit.center[1]),
        builder: (context) =>
            Icon(Icons.location_on, color: Colors.blue),
      );
    }
  }
}

Map<String, double> getMapBounds(LatLngBounds bounds) => {
      'SWLat': bounds.southWest.latitude,
      'SWLng': bounds.southWest.longitude,
      'NELat': bounds.northEast.latitude,
      'NELng': bounds.northEast.longitude,
    };
