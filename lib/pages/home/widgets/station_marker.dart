import 'package:flutter/material.dart';

import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../models/station/station.dart';

class StationMarker extends Marker {
  final Station station;
  final Function onTap;

  StationMarker(
    BuildContext context, {
    @required this.station,
    this.onTap,
  }) : super(
          height: 35,
          width: 35,
          point: LatLng(station.location.coordinates[0],
              station.location.coordinates[1]),
          anchorPos: AnchorPos.align(AnchorAlign.top),
          builder: (ctx) => InkWell(
            child: Image.asset('assets/marker.png'),
            onTap: onTap,
          ),
        );
}
